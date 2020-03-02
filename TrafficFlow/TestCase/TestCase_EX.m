function u_pre = TestCase_EX(bottom, left, right, dx, dt, XX, TT)

vmax = 100; kmax = 50;
ko = 25; qmax = 1250;
v = @(k) vmax.*(1-k/kmax);

dx = dx/1000;
dt = dt/60/60;
TT = TT/60;
J = int16(XX/dx);
N = int16(TT/dt);

u = zeros(J, (N+1)/2);
u(:,1) = bottom;
u(1,:) = left;
u(end,:) = right;

for n = 1:N/2
    A = zeros(J-2,J-2);
    b = zeros(J-2,1);
    for i = 3:J-2
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
    if     u(end-2,n)<=ko && u(end-1,n)<=ko && u(end,n)<=ko % 1.XXX
        A(end,end-1) = (dt/dx)*v(u(end-2,n));
        A(end,end) = 1-(dt/dx)*v(u(end-1,n));
    elseif u(end-2,n)<=ko && u(end-1,n)<=ko && u(end,n)>ko  % 2.XXO
        if v(u(end-1,n))*u(end-1,n)<v(u(end,n))*u(end,n)
            A(end,end-1) = (dt/dx)*v(u(end-2,n));
            A(end,end) = 1-(dt/dx)*v(u(end-1,n));
        else
            A(end,end-1) = (dt/dx)*v(u(end-2,n));
            A(end,end) = 1;
            b(end) = -(dt/dx)*v(u(end,n))*u(end,n);
        end
    elseif u(end-2,n)<=ko && u(end-1,n)>ko && u(end,n)<=ko % 3.XOX
        if v(u(end-2,n))*u(end-2,n)<v(u(end-1,n))*u(end-1,n)
            A(end,end-1) = (dt/dx)*v(u(end-2,n));
            A(end,end) = 1;
        else
            A(end,end) = 1+(dt/dx)*v(u(end-1,n));
        end
        b(end) = -(dt/dx)*qmax;
    elseif u(end-2,n)<=ko && u(end-1,n)>ko && u(end,n)>ko  % 4.XOO
        if v(u(end-2,n))*u(end-2,n)<v(u(end-1,n))*u(end-1,n)
            A(end,end-1) = (dt/dx)*v(u(end-2,n));
            A(end,end) = 1;
            b(end) = -(dt/dx)*v(u(end,n))*u(end,n);
        else
            A(end,end) = 1+(dt/dx)*v(u(end-1,n));
            b(end) = -(dt/dx)*v(u(end,n))*u(end,n);
        end
    elseif u(end-2,n)>ko && u(end-1,n)<=ko && u(end,n)<=ko % 5.OXX
        A(end,end) = 1-(dt/dx)*v(u(end-1,n));
        b(end) = (dt/dx)*qmax;
    elseif u(end-2,n)>ko && u(end-1,n)<=ko && u(end,n)>ko  % 6.OXO
        if v(u(end-1,n))*u(end-1,n)<v(u(end,n))*u(end,n)
            A(end,end) = 1-(dt/dx)*v(u(end-1,n));
            b(end) = (dt/dx)*qmax;
        else
            A(end,end) = 1;
            b(end) = (dt/dx)*(qmax-v(u(end,n))*u(end,n));
        end
    elseif u(end-2,n)>ko && u(end-1,n)>ko && u(end,n)<=ko % 7.OOX
        A(end,end) = 1+(dt/dx)*v(u(end-1,n));
        b(end) = -(dt/dx)*qmax;
    elseif u(end-2,n)>ko && u(end-1,n)>ko && u(end,n)>ko  % 8.OOO
        A(end,end) = 1+(dt/dx)*v(u(end-1,n));
        b(end) = -(dt/dx)*v(u(end,n))*u(end,n);
    end
    u_pre = A*u(2:end-1,n)+b;
    u(2:end-1,n+1) = u_pre;
end
u_pre = u(:,end);
end