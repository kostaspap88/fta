% Author: Kostas Papagiannopoulos -- kostaspap88@gmail.com -- kpcrypto.net

% Based on "Fault Template Attacks on block ciphers exploiting fault
% propagation", Saha et al.

% To keep the discussion simple, we assume that the fault detection 
% mechanism is activated right after every sbox computation (instead of
% after every pLayer operation)

clear all;
close all;



%--------------------------------------------------------------------------
% CASE A: KNOWN PLAINTEXT, UNMASKED IMPLEMENTATION, ALGORITHMS 1,2
%--------------------------------------------------------------------------

% PRESENT sbox fault template building

% this template (template1) can reduce the entropy of key to 1 bit
for k=0:15
    fault_pattern = zeros(16, 1);
    for p=0:15
        
        x = de2bi(bitxor(p, k), 4);
        % assume cipher duplication as fault detection mechanism
        % correct execution 
        [y1,y2,y3,y4] = sbox_correct(x(4),x(3),x(2),x(1));
        % incorrect execution
        [y1f,y2f,y3f,y4f] = sbox_faulty1(x(4),x(3),x(2),x(1));
        % if fault is detected in the sbox output
        if ((y1~=y1f) || (y2~=y2f) || (y3~=y3f) || (y4~=y4f))
            fault_pattern(p+1) = 1;
        else
            fault_pattern(p+1) = 0;
        end
    end
    
    template1{k+1} = fault_pattern;
    
end


% PRESENT sbox template matching

% produce the fault pattern of the correct key based on the fault that we 
% performed in template1 and sbox_faulty1
% the fault pattern relies on the key 
k_true = 7;
fault_pattern = zeros(16, 1);
for p=0:15
    
    x = de2bi(bitxor(p, k_true), 4);
    % assume cipher duplication as fauld detection mechanism
    % correct execution
    [y1,y2,y3,y4] = sbox_correct(x(4),x(3),x(2),x(1));
    % incorrect execution
    [y1f,y2f,y3f,y4f] = sbox_faulty1(x(4),x(3),x(2),x(1));
    % if fault is detected in the sbox output
    if ((y1~=y1f) || (y2~=y2f) || (y3~=y3f) || (y4~=y4f))
        fault_pattern(p+1) = 1;
    else
        fault_pattern(p+1) = 0;
    end
end

% match the correct key pattern to the fault templates
candidates_round1 =[];
for k=0:15
    if isequal(fault_pattern, template1{k+1})
        candidates_round1 = [candidates_round1; k];
    end
end

% Using k_true = 7  and the matching process of template1 the attack
% reduces the entropy of the key to 1bit, i.e. the 2 remaining candidates 
% are k=7 and k=5
% To find the key we need another fault profiling process (template2) that
% will distinguish between these 2 candidates

% this template (template2) can reduce the entropy of key to 3 bits and in
% conjuction with template1 it can lead to full key recovery
for k=0:15
    
    fault_pattern = zeros(16, 1);
    
    for p=0:15
        
        x = de2bi(bitxor(p, k), 4);
        % assume cipher duplication as fault detection mechanism
        % correct execution 
        [y1,y2,y3,y4] = sbox_correct(x(4),x(3),x(2),x(1));
        % incorrect execution
        [y1f,y2f,y3f,y4f] = sbox_faulty2(x(4),x(3),x(2),x(1));
        % if fault is detected in the sbox output
        if ((y1~=y1f) || (y2~=y2f) || (y3~=y3f) || (y4~=y4f))
            fault_pattern(p+1) = 1;
        else
            fault_pattern(p+1) = 0;
        end
    end
    
    template2{k+1} = fault_pattern;
    
end

% produce again the fault pattern of the correct key 
% under the new fault attack (as in template2, sbox_faulty2)
k_true = 7;
fault_pattern_round1_no2 = zeros(16, 1);
for p=0:15
    
    x = de2bi(bitxor(p, k_true), 4);
    % assume cipher duplication as fauld detection mechanism
    % correct execution
    [y1,y2,y3,y4] = sbox_correct(x(4),x(3),x(2),x(1));
    % incorrect execution
    [y1f,y2f,y3f,y4f] = sbox_faulty2(x(4),x(3),x(2),x(1));
    % if fault is detected in the sbox output
    if ((y1~=y1f) || (y2~=y2f) || (y3~=y3f) || (y4~=y4f))
        fault_pattern_round1_no2(p+1) = 1;
    else
        fault_pattern_round1_no2(p+1) = 0;
    end
end

% for the remaining key candidates (after matching with template1)
% we match them with template2
candidates_round1_no2 = [];
for k=candidates_round1'
    if isequal(fault_pattern_round1_no2, template2{k+1})
        candidates_round1_no2 = [candidates_round1_no2; k];
    end
end







%--------------------------------------------------------------------------
% CASE B: MIDDLE ROUNDS, UNKNOWN PLAINTEXT/CIPHERTEXT,
% UNMASKED IMPLEMENTATION, ALGORITHMS 3,4
%--------------------------------------------------------------------------

% p ---> XOR with key k ---> x ---> PRESENT SBOX ---> y ---> 
% FAULT DETECTION ---> observable


% Template building--------------------------------------------------------

% We start with plaintext p, xor it with the k then we feed the result to 
% the PRESENT SBOX.
% The output of gets tested for faults, comparing to a fault-free cipher 
% execution

% We create multiple templates for the same constant input by faulting
% different linear terms

% Note that a full attack would execute the remaining rounds of PRESENT and
% only in the end would it perform FAULT DETECTION

% The attack requires that the input to the middle round is constant and it
% is not necessary to know it


    
% Assume that the PRESENT plaintext is constant and as a result the input 
% to the middle-round that is under attack is also constant.
% Say that for a certaint constant plaintext the constant input of the
% middle round is zero. This input to the middle round is not known by 
% the adversary but knowledge is not necessary. So without loss of generality
% we assume that the constant input 'p' to the middle round is 0 and is
% unknown to the attacker.

p = 0;
template_middle = zeros(16,4);
% for all fault positions
for fault_position=1:4
    
    fault_pattern_mid = zeros(16, 1);
    % for all keys
    for k=0:15
        
        x = de2bi(bitxor(p, k), 4);
        % assume cipher duplication as fault detection mechanism
        % correct execution 
        [y1,y2,y3,y4] = sbox_correct(x(4),x(3),x(2),x(1));
        % incorrect execution
        [y1f,y2f,y3f,y4f] = sbox_linearfault(x(4),x(3),x(2),x(1), fault_position);
        % if fault is detected in the sbox output
        if ((y1~=y1f) || (y2~=y2f) || (y3~=y3f) || (y4~=y4f))
            fault_pattern_mid(k+1) = 1;
        else
            fault_pattern_mid(k+1) = 0;
        end
    end
    
    template_middle(:, fault_position) = fault_pattern_mid;
    
end


% Template matching--------------------------------------------------------
% - keep the input to PRESENT cipher constant and same to the constant
% input used during the template building phase
% - repeat the faults at the same linear terms of the sbox computation like
% the faults during profiling

% set the true (unknown) key
k_true = 10;
middle_fault_pattern_true = zeros(4, 1);
% using the same constant input like the template building phase will
% result in the same constant input to the middle round. 
% Thus, again the input is 0
p = 0;
for fault_position=1:4
    
    x = de2bi(bitxor(p, k_true), 4);
    % assume cipher duplication as fauld detection mechanism
    % correct execution
    [y1,y2,y3,y4] = sbox_correct(x(4),x(3),x(2),x(1));
    % incorrect execution
    [y1f,y2f,y3f,y4f] = sbox_linearfault(x(4),x(3),x(2),x(1), fault_position);
    % if fault is detected in the sbox output
    if ((y1~=y1f) || (y2~=y2f) || (y3~=y3f) || (y4~=y4f))
        middle_fault_pattern_true(fault_position) = 1;
    else
        middle_fault_pattern_true(fault_position) = 0;
    end
end


% match the correct middle-round key pattern to the middle-round templates
candidates_middle =[];
for k=0:15
    if isequal(middle_fault_pattern_true, template_middle(k+1,:)')
        candidates_middle = [candidates_middle; k];
    end
end








%--------------------------------------------------------------------------
% CASE C: MASKED PRESENT, MIDDLE ROUNDS, UNKNOWN PLAINTEXT/CIPHERTEXT
% ALGORITHMS 5,6
%--------------------------------------------------------------------------

% p ---> XOR with key k ---> x ---> SPLIT ---> x_i_j ---> F --->
% f_i_j ---> RECOMBINE ---> f ---> FAULT DETECTION ---> observable

% Template building--------------------------------------------------------

% We start with plaintext p, xor it with the k (this should be done in a
% masked way but here we ommit for simplicity)
% Then we split the result 4-bit value x to 3 shares that we feed to the
% shared function F
% The output of F is in 3 shares and gets recombined to produce f. Then f
% gets tested for faults, comparing to a fault-free cipher execution

% Note that a full attack would execute the remaining rounds of PRESENT and
% only in the end it would RECOMBINE and perform FAULT DETECTION

% The attack requires that the input to the middle round is constant and it
% is not necessary to know it


% plaintext (or unknown constant input to the middle round)
p = 0;
% number of times to repeat the fault injection
M = 10;
template_masked = zeros(16, 4);

% for all fault positions
for fault_position=1:4    
    
    % for all keys
    for k=0:15
        
        % repeat fault injection multiple times since we may not have
        % propagation due to the random masks
        V = [];
        for m_ind = 1:M
            
            
            x = de2bi(bitxor(p, k), 4);
            
            [f10, f20, f30, f11, f21, f31, f12, f22, f32, f13, f23, f33] = masked_sbox_correct(x(4),x(3),x(2),x(1));
            [ff10, ff20, ff30, ff11, ff21, ff31, ff12, ff22, ff32, ff13, ff23, ff33] = masked_sbox_faulty(x(4),x(3),x(2),x(1), fault_position);
            
            % recombine shares for the respective fault injection spot
            if fault_position == 1
                y_correct = bitxor(f10, bitxor(f20, f30));
                y_faulty = bitxor(ff10, bitxor(ff20, ff30));
            end
            if fault_position == 2
                y_correct = bitxor(f11, bitxor(f21, f31));
                y_faulty = bitxor(ff11, bitxor(ff21, ff31));
            end
            if fault_position == 3
                y_correct = bitxor(f12, bitxor(f22, f32));
                y_faulty = bitxor(ff12, bitxor(ff22, ff32));
            end
            if fault_position == 4
                y_correct = bitxor(f13, bitxor(f23, f33));
                y_faulty = bitxor(ff13, bitxor(ff23, ff33));
            end
            
            % if fault is detected in the sbox output the register it
            if y_correct ~= y_faulty
               V = [V 1];
            else
               V = [V 0];
            end
            
        end
        
        % if there is at least one fault registered, set the fault tempate at
        % 1, else set it at zero. For large M this rule holds (see page 24)
        if isequal(V,zeros(1,M))
            template_masked(k+1, fault_position) = 0;
        else
            template_masked(k+1, fault_position) = 1;
        end
        
    end
    
end


% Template matching--------------------------------------------------------

% plaintext (or unknown constant input to the middle round)
p = 0;
% number of times to repeat the fault injection
M = 10;
% true key 
k_true = 9;

% for all fault positions
for fault_position=1:4    
    
        
    % repeat fault injection multiple times since we may not have
    % propagation due to the random masks
    V = [];
    for m_ind = 1:M


        x = de2bi(bitxor(p, k_true), 4);

        [f10, f20, f30, f11, f21, f31, f12, f22, f32, f13, f23, f33] = masked_sbox_correct(x(4),x(3),x(2),x(1));
        [ff10, ff20, ff30, ff11, ff21, ff31, ff12, ff22, ff32, ff13, ff23, ff33] = masked_sbox_faulty(x(4),x(3),x(2),x(1), fault_position);

        % recombine shares for the respective fault injection spot
        if fault_position == 1
            y_correct = bitxor(f10, bitxor(f20, f30));
            y_faulty = bitxor(ff10, bitxor(ff20, ff30));
        end
        if fault_position == 2
            y_correct = bitxor(f11, bitxor(f21, f31));
            y_faulty = bitxor(ff11, bitxor(ff21, ff31));
        end
        if fault_position == 3
            y_correct = bitxor(f12, bitxor(f22, f32));
            y_faulty = bitxor(ff12, bitxor(ff22, ff32));
        end
        if fault_position == 4
            y_correct = bitxor(f13, bitxor(f23, f33));
            y_faulty = bitxor(ff13, bitxor(ff23, ff33));
        end

        % if fault is detected in the sbox output the register it
        if y_correct ~= y_faulty
           V = [V 1];
        else
           V = [V 0];
        end

    end

    % if there is at least one fault registered, set the fault tempate at
    % 1, else set it at zero. For large M this rule holds (see page 24)
    if isequal(V,zeros(1,M))
        masked_fault_pattern_true(fault_position,1) = 0;
    else
        masked_fault_pattern_true(fault_position,1) = 1;
    end
        
    
    
end


% match the correct key pattern to the fault templates
candidates_masked =[];
for k=0:15
    if isequal(masked_fault_pattern_true', template_masked(k+1,:))
        candidates_masked = [candidates_masked; k];
    end
end

% if we have more than 1 key candidates, then attacking a different
% position may help...



% Final notes: I was not able to reproduce Table 7
            




