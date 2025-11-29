// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
    Smart Arbitration for Gig Markets
    - Automatically resolves disputes between clients & freelancers
*/

contract SmartArbitration {
    address public platformAdmin;

    enum DisputeStatus { Open, Resolved }
    
    struct Dispute {
        uint256 jobId;
        address client;
        address freelancer;
        string issue;
        DisputeStatus status;
        address winner;
    }

    uint256 public disputeCount = 0;
    mapping(uint256 => Dispute) public disputes;

    constructor() {
        platformAdmin = msg.sender;
    }

    // 1️⃣ File a dispute (Client or Freelancer)
    function fileDispute(uint256 _jobId, address _freelancer, string calldata _issue) 
        external 
        returns (uint256) 
    {
        disputeCount++;
        disputes[disputeCount] = Dispute({
            jobId: _jobId,
            client: msg.sender,
            freelancer: _freelancer,
            issue: _issue,
            status: DisputeStatus.Open,
            winner: address(0)
        });

        return disputeCount;
    }

    // 2️⃣ Resolve a dispute (Only Admin)
    function resolveDispute(uint256 _disputeId, address _winner) external {
        require(msg.sender == platformAdmin, "Only admin can resolve disputes");
        require(disputes[_disputeId].status == DisputeStatus.Open, "Already resolved");

        disputes[_disputeId].status = DisputeStatus.Resolved;
        disputes[_disputeId].winner = _winner;
    }

    // 3️⃣ Fetch dispute details
    function getDispute(uint256 _disputeId) 
        external 
        view 
        returns (Dispute memory) 
    {
        return disputes[_disputeId];
    }
}

