function DecideAccept(obj)

% Sets the "Accept" property to true if the proposed point should be
% accepted, and to false otherwise 

u = rand;

if obj.LogAcceptanceRatio > log(u)
    obj.AcceptProposal = true;
elseif obj.LogAcceptanceRatio < log(u)
    obj.AcceptProposal = false;
end
            
end