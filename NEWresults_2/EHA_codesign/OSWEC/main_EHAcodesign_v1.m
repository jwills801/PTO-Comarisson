clear, close all
kp_0 = 2.9897e7;
ki_0 = 3.2542e7;
x0 = [kp_0;ki_0];

return
tStart = tic;

options = optimset('PlotFcns',@optimplotfval);
%[x,fval] = fminsearch(@fun,x0,options)

% nvars = 2; options = optimoptions('ga','PlotFcn', @gaplotbestf);
% [x,fval] = ga(@fun,nvars,[],[],[],[],zeros(nvars,1),[],[],options);

TimeElapsed = toc(tStart)  

%%
N = 2;
k_vals = linspace(5e6,10e7,N);

KP = NaN(N,N); KI = KP; J = KP;
outertime = tic;
for i = 1:N
    for j = 1:N
        KP(i,j) = k_vals(i);
        KI(i,j) = k_vals(j);
        J(i,j) = fun([k_vals(i) ; k_vals(j)]);
        disp([num2str((i-1)*N+j) ' of ' num2str(N*N) ' simulations complete'])
    end
end
toc(outertime)
figure, contour(KP,KI,J,N), xlabel('K_p'), ylabel('K_i'), xlim([.5e7 5e7]), ylim([.5e7 10e7])

KP_ = KP(:); KI_ = KI(:); J_ = J(:);
[a,b] = min(J_);
disp('Best case was:')
disp(['              ' num2str(-a/1e6) ' MJ'])
disp(['    with Kp = ' num2str(KP_(b)/1e7) 'e7'])
disp(['     and Ki = ' num2str(KI_(b)/1e7) 'e7'])



%%
kp = 1.9e07;                             % PTO Damping Coeff [Nsm/rad]
ki = 3.3e7; 
fun([kp ki])

function J = fun(x)
kp = x(1);
ki = x(2);
%A = x(3);
[~]=evalc('wecSim');
EHA_losses;
J = Work_Out;
%J = Work_in;
end