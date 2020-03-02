function [u_grid, u_pre] = Traffic_EX(bottom, left, past_time, want_predict_time, dt)
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

left_inter = interpolation(left, N*(want_predict_time+past_time)+1);

% 邊界條件
u = zeros(J+1, N*want_predict_time+1);
u(:,1) = interpolation(bottom, J+1);
u(1,:) = left_inter((past_time)*N+1:end);

for n = 1:N*want_predict_time
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
u_grid = u(1:J/37:end, :);
u_pre = u_grid(:,1:N:end);
end