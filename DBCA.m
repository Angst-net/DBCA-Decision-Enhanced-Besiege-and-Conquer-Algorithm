%  DBCA: A cost-benefit decision-enhanced Besiege and Conquer algorithm for global optimization
%
%  Source code v1.0
%
%  Main Paper:
%    Chenxu Guo, Jianhua Jiang, Shuxin Guo, Zhuo Li, Weihua Li,
%    DBCA: A cost-benefit decision-enhanced Besiege and Conquer algorithm for global optimization,
%    Expert Systems with Applications,
%    VOLUME = {334},
%    YEAR = {2027},
%    ARTICLE-NUMBER = {134608},
%    10.1016/j.eswa.2026.134608
%______________________________________________________________________________________________


function [gBestObj, gBestPos, convergence] = DBCA(SearchAgents_no, Max_iter, lb, ub, dim, fobj)
%% Parameter initialization
Particle_Number = SearchAgents_no;         % Total number of soldiers in the population
nSoldiers = 3;                             % Number of soldiers in each army
nArmies = round(Particle_Number/nSoldiers);% Number of armies
D = dim;                                   % Dimension of the optimization problem
Max_Gen = Max_iter;                        % Maximum iteration number
fes_number = 0;                            % Counter of function evaluations
fes = Particle_Number;% Initial consumed function evaluations
ub = ub .* ones(1,D);% Upper bound
lb = lb .* ones(1,D);% Lower bound
bound_repair_value = 0.7 * ones(1,Max_Gen); %boundary repair value
lambda_constraint = 1.0;                    % parameter lambda
armies = initialization(Particle_Number,D,ub,lb);% Initialize positions of armies
obj_armies = zeros(1,nArmies);% Objective value of each army
convergence = zeros(1,Max_Gen);% Convergence curve to record global best each generation

% Initial fitness evaluation for all armies
for i = 1:nArmies
    obj_armies(i) = fobj(armies(i,:));
end
[best, indis] = min(obj_armies);
best_army = armies(indis,:);
t = 1;
fireTimes = 0;

%% main loop
while t <= Max_Gen
    [~, ind] = sort(obj_armies);
    elite_armies = armies(ind(1:min(3,nArmies)),:);
    elite_fitness = obj_armies(ind(1:min(3,nArmies)));
    weights = 1 ./ elite_fitness;
    norm_weights = weights / sum(weights);
    
    for i = 1:nArmies
        soldiers = zeros(nSoldiers,D);
        obj_soldiers = zeros(1,nSoldiers);
        bound_repair_value(t) = 0.7 - 0.3*(t/Max_Gen)^2;
        for j = 1:nSoldiers
            r = fix(rand*nArmies)+1;
            while r == i
                r = fix(rand*nArmies)+1;
            end
            
            candidates = zeros(3,D);
            for d = 1:D
                alpha = rand*2*pi;
                beta = rand*2*pi;
                rs = rand(1,D)*2-1;
                unit_vector = rs/norm(rs);
                
                % Inverse fitness proportional weighting mechanism
                soldier1 = elite_armies(1,d) + abs(armies(r,d)-armies(i,d))*sin(alpha);
                soldier2 = elite_armies(min(2,end),d) + abs(armies(r,d)-armies(i,d))*sin(alpha);
                soldier3 = elite_armies(min(3,end),d) + abs(armies(r,d)-armies(i,d))*sin(alpha);
                candidates(1,d) = norm_weights(1)*soldier1 + norm_weights(2)*soldier2 + norm_weights(3)*soldier3;
                
                % Feedback-driven directional search mechanism
                spatial_scale = norm(armies(r,:) - armies(i,:));
                base_step = spatial_scale * (1 - t / Max_Gen);
                success_ratio = abs(obj_armies(i) - best) / (abs(best) + eps);
                adaptive_factor = 1 + tanh(success_ratio);
                step = base_step * adaptive_factor * rand;
                candidates(2,d) = armies(i,d) + step * unit_vector(d);

                % Controlled harmonic exploration mechanism
                eta_i = (obj_armies(i) - best) / (max(obj_armies) - best + eps);
                C_d = (lb(d) + ub(d)) / 2;
                A0_d = (ub(d) - lb(d)) / 2;
                A_eff = A0_d * eta_i * (1 - t / Max_Gen);
                phi_d = 2 * pi * (armies(i,d) - lb(d)) / (ub(d) - lb(d) + eps);
                omega_d = pi * (1 + rand);
                candidates(3,d) = C_d + A_eff * cos(omega_d * t + phi_d);

               % Boundary constraint handling
                for m = 1:3
                    if candidates(m,d) > ub(d) || candidates(m,d) < lb(d)
                        if m == 1
                            candidates(m,d) = bound_repair_value(t)*best_army(d) + (1-bound_repair_value(t))*armies(i,d);
                        else
                            candidates(m,d) = lb(d) + (ub(d)-lb(d))*rand;
                        end
                    end
                end
            end
            
            % Cost-benefit decision mechanism 
            decision_values = zeros(1,3);
            for m = 1:3
                f_candidate = fobj(candidates(m,:));
                delta_f = (obj_armies(i)-f_candidate) / ...
          (max(abs(obj_armies(i)),abs(f_candidate))+eps);
                energy = mean( ((candidates(m,:) - armies(i,:)) ./ (ub - lb)).^2 );
                decision_values(m) = delta_f - lambda_constraint * energy;
            end
            
            
            [~, best_strategy] = max(decision_values);
            soldiers(j,:) = candidates(best_strategy,:);
            obj_soldiers(j) = fobj(soldiers(j,:));
            fes_number = fes_number + nSoldiers;
        end
        
        % Update the army leader if the best soldier outperforms current army
        [tmp_best, best_idx] = min(obj_soldiers);
        if tmp_best < obj_armies(i)
            armies(i,:) = soldiers(best_idx,:);
            obj_armies(i) = tmp_best;
        end
    end
    
    % Update global best solution
    [tmp_best, indis] = min(obj_armies);
    if tmp_best < best
        best = tmp_best;
        best_army = armies(indis,:);
    end
    convergence(t) = best;
    t = t + 1;
end
gBestPos = best_army;
gBestObj = best;
end

%% Initialization function
function positions = initialization(SearchAgents_no, dim, ub, lb)
positions = zeros(SearchAgents_no, dim);
for i = 1:SearchAgents_no
    positions(i,:) = lb + (ub-lb).*rand(1,dim);
end
end
