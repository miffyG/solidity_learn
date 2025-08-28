// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/**
    1.  创建一个名为Voting的合约，包含以下功能：
    一个mapping来存储候选人的得票数
    一个vote函数，允许用户投票给某个候选人
    一个getVotes函数，返回某个候选人的得票数
    一个resetVotes函数，重置所有候选人的得票数
*/
contract Voting {
    // 存储候选人的得票数
    mapping (string => uint) private _candidateVotes;
    // 标记候选人是否已存在
    mapping (string => bool) private _candidateExists;
    // 记录已投票候选人
    string[] private _votedCandidates;
    
    // 给候选人投票
    function vote(string calldata candidate) external { 
        if (!_candidateExists[candidate]) {
            _candidateExists[candidate] = true;
            _votedCandidates.push(candidate);
        }
        _candidateVotes[candidate] += 1;
    }

    // 返回某个候选人的得票数
    function getVotes(string calldata candidate) external view returns (uint) {
        return _candidateVotes[candidate];
    }

    //重置所有候选人的得票数
    function resetVotes() external {
        for (uint i = 0; i < _votedCandidates.length; i++) {
            string memory c = _votedCandidates[i];
            _candidateVotes[c] = 0;
            _candidateExists[c] = false;
        }
        delete _votedCandidates;
    }
}