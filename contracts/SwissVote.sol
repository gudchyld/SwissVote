// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract SwissVote {
    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint vote;
    }

    string public title;

    Candidate[] public candidates;
    mapping(address => Voter) voters;

    function createPoll(
        string calldata _title,
        string[] calldata _candidates
    ) external {
        title = _title;
        for (uint i = 0; i < _candidates.length; i++) {
            candidates.push(Candidate({name: _candidates[i], voteCount: 0}));
        }
    }

    function getCandidates() external view returns (Candidate[] memory) {
        return candidates;
    }

    function castVote(uint candidate) external {
        require(
            address(msg.sender).balance > 0.1 ether,
            "INSUFFICIENT BALANCE TO VOTE"
        );
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = candidate;
        candidates[candidate].voteCount += 1;
    }

    function votersBalance() public view returns (uint) {
        return address(msg.sender).balance;
    }

    function hasVote(address _address) external view returns (bool) {
        Voter memory sender = voters[_address];
        return sender.voted;
    }

    function winningCandidate() public view returns (uint _winningCandidate) {
        uint winningVoteCount = 0;

        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                _winningCandidate = p;
            }
        }
    }

    function winnerName() public view returns (string memory _winnerName) {
        _winnerName = candidates[winningCandidate()].name;
    }
}
