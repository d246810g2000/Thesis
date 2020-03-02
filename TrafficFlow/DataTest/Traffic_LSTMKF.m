function [u_grid, u_pre] = Traffic_LSTMKF(history, left, past_time, want_predict_time, update_time, dt)
% MacNicholas model
vf = 89.16; kj = 191.99; ko = 56.70;
v = @(k) vf.*((kj.^1.81-k.^1.81)./(kj.^1.81+6.83.*k.^1.81));
qmax = v(ko)*ko;

dt = dt/60/60;
TT = 1/12;
N = int16(TT/dt);
XX = 13.62;
J = 37;
dx = XX/J;

Q = dx^2*eye(J); % model error covariance
Pa = eye(J); % initial analysis error covariance
R = 0.01*eye(J); % observation error covariance
R1 = R;
nsteps = update_time; % do assimilation every nsteps steps

left_inter = interpolation(left, N*(want_predict_time+past_time)+1);
bottom = history(:,1);

% 邊界條件
u_grid = zeros(J+1, N*want_predict_time+1);

for k = 1:want_predict_time
    u = zeros(J+1, N+1);
    u(:,1) = interpolation(bottom(:,k), J+1);
    u(1,:) = left_inter(N*(past_time+k-1)+1:N*(past_time+k)+1);
    for n = 1:N
        A = zeros(J,J);
        b = zeros(J,1);
        for i = 3:J
            v1 = v(u(i-1,n));
            v2 = v(u( i ,n));
            v3 = v(u(i+1,n));
            % inter point       
            if     u(i-1,n)<=ko && u(i,n)<=ko && u(i+1,n)<=ko % 1.XXX
                A(i-1,i-2) = (dt/dx)*v1; A(i-1,i-1) = 1-(dt/dx)*v2; A(i-1,i) = 0;
            elseif u(i-1,n)<=ko && u(i,n)<=ko && u(i+1,n)>ko  % 2.XXO
                if v2*u(i,n)<v3*u(i+1,n)
                    A(i-1,i-2) = (dt/dx)*v1; A(i-1,i-1) = 1-(dt/dx)*v2; A(i-1,i) = 0;
                else
                    A(i-1,i-2) = (dt/dx)*v1; A(i-1,i-1) = 1; A(i-1,i) = -(dt/dx)*v3;
                end
            elseif u(i-1,n)<=ko && u(i,n)>ko  && u(i+1,n)<=ko % 3.XOX
                if v1*u(i-1,n)<v2*u(i,n)
                    A(i-1,i-2) = (dt/dx)*v1; A(i-1,i-1) = 1; A(i-1,i) = 0;
                else
                    A(i-1,i-2) = 0; A(i-1,i-1) = 1+(dt/dx)*v2; A(i-1,i) = 0;
                end
                b(i-1) = -(dt/dx)*qmax;
            elseif u(i-1,n)<=ko && u(i,n)>ko  && u(i+1,n)>ko  % 4.XOO
                if v1*u(i-1,n)<v2*u(i,n)
                    A(i-1,i-2) = (dt/dx)*v1; A(i-1,i-1) = 1; A(i-1,i) = -(dt/dx)*v3;
                else
                    A(i-1,i-2) = 0; A(i-1,i-1) = 1+(dt/dx)*v2; A(i-1,i) = -(dt/dx)*v3;
                end
            elseif u(i-1,n)>ko  && u(i,n)<=ko && u(i+1,n)<=ko % 5.OXX
                A(i-1,i) = 0; A(i-1,i-1) = 1-(dt/dx)*v2; A(i-1,i) = 0;
                b(i-1) = (dt/dx)*qmax;
            elseif u(i-1,n)>ko  && u(i,n)<=ko && u(i+1,n)>ko  % 6.OXO
                if v2*u(i,n)<v3*u(i+1,n)
                    A(i-1,i-2) = 0; A(i-1,i-1) = 1-(dt/dx)*v2; A(i-1,i) = 0;
                else
                    A(i-1,i-2) = 0; A(i-1,i-1) = 1; A(i-1,i) = -(dt/dx)*v3;
                end
                b(i-1) = (dt/dx)*qmax;
            elseif u(i-1,n)>ko  && u(i,n)>ko  && u(i+1,n)<=ko % 7.OOX
                A(i-1,i-2) = 0; A(i-1,i-1) = 1+(dt/dx)*v2; A(i-1,i) = 0;
                b(i-1) = -(dt/dx)*qmax;
            elseif u(i-1,n)>ko  && u(i,n)>ko  && u(i+1,n)>ko  % 8.OOO
                A(i-1,i-2) = 0; A(i-1,i-1) = 1+(dt/dx)*v2; A(i-1,i) = -(dt/dx)*v3;
            end
        end

        % left boundary
        if     u(1,n)<=ko && u(2,n)<=ko && u(3,n)<=ko % 1.XXX
            A(1,1) = 1-(dt/dx)*v(u(2,n));
            b(1) = (dt/dx)*v(u(1,n))*u(1,n);
        elseif u(1,n)<=ko && u(2,n)<=ko && u(3,n)>ko  % 2.XXO
            if v(u(2,n))*u(2,n)<v(u(3,n))*u(3,n)
                A(1,1) = 1-(dt/dx)*v(u(2,n));
            else
                A(1,1) = 1;
                A(1,2) = -(dt/dx)*v(u(3,n));
            end
            b(1) = (dt/dx)*v(u(1,n))*u(1,n);
        elseif u(1,n)<=ko && u(2,n)>ko && u(3,n)<=ko % 3.XOX
            if v(u(1,n))*u(1,n)<v(u(2,n))*u(2,n)
                A(1,1) = 1;
                b(1) = -(dt/dx)*(qmax-v(u(1,n))*u(1,n));
            else
                A(1,1) = 1+(dt/dx)*v(u(2,n));
                b(1) = -(dt/dx)*qmax;
            end
        elseif u(1,n)<=ko && u(2,n)>ko  && u(3,n)>ko  % 4.XOO
            if v(u(1,n))*u(1,n)<v(u(2,n))*u(2,n)
                A(1,1) = 1; A(1,2) = -(dt/dx)*v(u(3,n));
                b(1) = (dt/dx)*v(u(1,n))*u(1,n);
            else
                A(1,1) = 1+(dt/dx)*v(u(2,n)); A(1,2) = -(dt/dx)*v(u(3,n));
            end
        elseif u(1,n)>ko  && u(2,n)<=ko && u(3,n)<=ko % 5.OXX
            A(1,1) = 1-(dt/dx)*v(u(2,n));
            b(1) = (dt/dx)*qmax;
        elseif u(1,n)>ko  && u(2,n)<=ko && u(3,n)>ko  % 6.OXO
            if v(u(2,n))*u(2,n)<v(u(3,n))*u(3,n)
                A(1,1) = 1-(dt/dx)*v(u(2,n));
            else
                A(1,1) = 1; A(1,2) = -(dt/dx)*v(u(3,n));
            end
            b(1) = (dt/dx)*qmax;
        elseif u(1,n)>ko  && u(2,n)>ko  && u(3,n)<=ko % 7.OOX
            A(1,1) = 1+(dt/dx)*v(u(2,n));
            b(1) = -(dt/dx)*qmax;
        elseif u(1,n)>ko  && u(2,n)>ko  && u(3,n)>ko  % 8.OOO
            A(1,1) = 1+(dt/dx)*v(u(2,n)); A(1,2) = -(dt/dx)*v(u(3,n));
        end

        % right boundary
        if     u(end-1,n)<=ko && u(end,n)<=ko % 1.XXX
            A(end,end-1) = (dt/dx)*v(u(end-1,n));
            A(end,end) = 1-(dt/dx)*v(u(end,n));
        elseif u(end-1,n)<=ko && u(end,n)>ko % 2.XOX
            if v(u(end-1,n))*u(end-1,n)<v(u(end,n))*u(end,n)
                A(end,end-1) = (dt/dx)*v(u(end-1,n));
                A(end,end) = 1;
            else
                A(end,end) = 1+(dt/dx)*v(u(end,n));
            end
            b(end) = -(dt/dx)*qmax;
        elseif u(end-1,n)>ko && u(end,n)<=ko % 3.OXX
            A(end,end) = 1-(dt/dx)*v(u(end,n));
            b(end) = (dt/dx)*qmax;
        elseif u(end-1,n)>ko && u(end,n)>ko % 4.OOX
            A(end,end) = 1+(dt/dx)*v(u(end,n));
            b(end) = -(dt/dx)*qmax;
        end
        u_pre = A*u(2:end,n)+b;
        u(2:end,n+1) = u_pre;
    end
    u(2:end,end) = u(2:end,end) + (randn(1,J)*sqrtm(Q))';
    Xf = u(:,end);
    if k < want_predict_time && k == nsteps
        % correction step
        Y = interpolation(history(:,k+1), J+1); % new observations from noise about truth
        Pf = A*Pa*A'+Q; % new background error covariance
        K = (Pf+R)\Pf; % Kalman gain
        u_pre = zeros(J+1,1);
        u_pre(1) = Xf(1);   
        u_pre(2:end) = Xf(2:end) + K*(Y(2:end)'-Xf(2:end));
        Pa = (eye(J)-K)*Pf;
        nsteps = nsteps + update_time;
        bottom(:,k+1) = u_pre;
        R = R+R1;
    else
        bottom(:,k+1) = Xf;
    end
    % save grid
    if k == 1
        u_grid(:,1:N+1) = u;
    else
        u_grid(:,N*(k-1)+2:N*k+1) = u(:,2:end);
    end
end
u_pre = bottom;
end