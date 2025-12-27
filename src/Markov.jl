# --- Markov models --------------------------------------------------------------------------- #
function _simulate(m::MyHiddenMarkovModel, start::Int64, steps::Int64)::Array{Int64,2}

    # initialize -
    chain = Array{Int64,2}(undef, steps, 2);
    chain[1,1] = start;
    chain[1,2] = 0; # no jump indicator

    # main loop -
    for i ∈ 2:steps
        chain[i,1] = rand(m.transition[chain[i-1]]);
        chain[i,2] = 0; # no jump indicator
    end

    return chain;
end


function _simulate(m::MyHiddenMarkovModelWithJumps, start::Int64, steps::Int64)::Array{Int64,2}

    # initialize -
    chain = Array{Int64,2}(undef, steps, 2); # two columns: state, jump indicator
    tmp_chain = Dict{Int64,Int64}();
    tmp_jump = Dict{Int64,Int64}();
    tmp_chain[1] = start;
    tmp_jump[1] = 0; # no jump indicator
    counter = 2;

    # main -
    jump_state = start;
    while (counter ≤ steps)
        
        if (rand() < m.ϵ) # small probability of jump

            # # jump: find the next state. It is lowest probability state from here
            number_of_jumps = rand(m.jump_distribution); # Possion: how many steps to take in jump state 
            number_of_states = length(m.states);
            bottom_states = [1,2,3,4,5]; # super bad
            top_states = [number_of_states-4, number_of_states-3, number_of_states-2, number_of_states-1, number_of_states]; # super good


            for _ ∈ 1:number_of_jumps
                if (rand() < 0.52)
                    tmp_chain[counter] = rand(bottom_states) # a jump transition to bottom states
                    tmp_jump[counter] = 1; # indicate a jump occurred
                else
                    tmp_chain[counter] = rand(top_states) # a jump transition to top states
                    tmp_jump[counter] = 1; # indicate a jump occurred
                end
                counter += 1;
            end
        else
            tmp_chain[counter] = rand(m.transition[jump_state]); # a normal transition
            tmp_jump[counter] = 0; # indicate no jump occurred
            counter += 1; # increment counter
        end

        jump_state = tmp_chain[counter-1]; # get the last state
    end

    # populate the chain from tmp_chain -
    for i ∈ 1:steps
        chain[i,1] = tmp_chain[i];
        chain[i,2] = tmp_jump[i];
    end

    # return -
    return chain;
end

(m::MyHiddenMarkovModel)(start::Int64, steps::Int64) = _simulate(m, start, steps); 
(m::MyHiddenMarkovModelWithJumps)(start::Int64, steps::Int64) = _simulate(m, start, steps); 
