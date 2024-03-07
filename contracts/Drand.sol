// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {DrandVerifyLib} from "./libraries/DrandVerify.sol";
import {BotLib} from "./libraries/Bot.sol";
import {Gateway} from "./Gateway.sol";

/// @title Drand contract
/// @author Jidooochan
contract Drand {
    error RoundTooLow();
    error Unauthorized();
    error InvalidPubkey();
    error InvalidSignture();
    error SignatureDoesNotMatchState();
    error SubmissionExists();
    error UnregisteredBot();
    error MaliciousBot();

    event BotRegistered(string moniker, address indexed botAddress);
    event BlacklistAdded(address[] add);
    event BlacklistRemoved(address[] remove);
    event ConfigChanged(
        address indexed gateway,
        address indexed manager,
        uint minRound
    );
    event RoundSubmitted(
        uint round,
        bytes32 randomness,
        address indexed botAddress
    );

    /// Constant defining how many submissions per round must be verified
    uint public constant NUMBER_OF_SUBMISSION_VERIFICATION_PER_ROUND = 3;

    /// Manager for bot addr de/allowlist
    address public manager;

    /// The address of the nois-gateway contract
    address public gateway;

    /// The lowest drand round this contracts accepts for verification and storage.
    uint public minRound;

    struct Bot {
        string moniker;
        uint roundsAdded;
    }

    struct VerifiedBeacon {
        uint verifiedTime; // Timestamp
        bytes32 randomness; // The sha256(signature)
    }

    struct StoredSubmission {
        uint pos; // The position which this submission was made within one round.
        uint time; // Submission time (block time)
        uint height; // Submission block height
    }

    /// The number of submissions done for each round
    mapping(uint => uint) submissionsCount;

    mapping(address => Bot) bots;

    mapping(address => bool) blacklist;

    /// A map from round number to drand beacon
    /// round_number => {verified_time, randomness}
    mapping(uint => VerifiedBeacon) beacons;

    /// Stores the submission
    /// round_number => {address, stored_submission at this round by this address}
    mapping(uint => mapping(address => StoredSubmission)) submissions;

    constructor(address _manager, uint _minRound) {
        manager = _manager;
        minRound = _minRound;
    }

    /// This function submits the randomness from the bot to Radone
    function addRound(uint round, bytes memory signature) external {
        if (round < minRound) revert RoundTooLow();
        if (bytes(bots[msg.sender].moniker).length == 0)
            revert UnregisteredBot();
        if (blacklist[msg.sender]) revert MaliciousBot();

        Gateway gatewayContract = Gateway(gateway);

        // Get the number of submission before this one.
        uint submissionsCountAtThisRound = submissionsCount[round];
        bytes32 randomness = DrandVerifyLib.deriveRandomness(signature);

        // Check if we need to verify the submission  or we just compare it to the registered randomness from the first submission of this round
        bool isVerifyingTx;

        if (
            submissionsCountAtThisRound <
            NUMBER_OF_SUBMISSION_VERIFICATION_PER_ROUND
        ) {
            isVerifyingTx = true;
        } else {
            isVerifyingTx = false;
            bytes32 alreadyVerifiedRandomnessForThisRound = beacons[round]
                .randomness;
            if (randomness != alreadyVerifiedRandomnessForThisRound)
                revert SignatureDoesNotMatchState();
        }
        if (submissions[round][msg.sender].time != 0) revert SubmissionExists();

        if (gateway != address(0)) {
            gatewayContract.addVerifiedRound(round, randomness, isVerifyingTx);
        }

        // Store the submisstion
        submissions[round][msg.sender] = StoredSubmission(
            submissionsCountAtThisRound + 1,
            block.timestamp,
            block.number
        );

        // Update the submission count of this round
        submissionsCount[round] += 1;

        // Update bot's state
        bots[msg.sender] = Bot(
            bots[msg.sender].moniker,
            bots[msg.sender].roundsAdded + 1
        );

        // Store the verified beacon
        // Note: Round already been verified must not be overriden to not get a wrong `verified` timestamp.
        if (beacons[round].verifiedTime == 0) {
            beacons[round] = VerifiedBeacon(block.timestamp, randomness);
        }

        emit RoundSubmitted(round, randomness, msg.sender);
    }

    function registerBot(string memory _moniker) external {
        require(BotLib.validateMoniker(_moniker));
        bots[msg.sender] = Bot(_moniker, 0);
        emit BotRegistered(_moniker, msg.sender);
    }

    function addBotToBlacklist(address[] calldata add) external {
        if (msg.sender != manager) revert Unauthorized();
        for (uint i = 0; i < add.length; i++) {
            blacklist[add[i]] = true;
        }
        emit BlacklistAdded(add);
    }

    function removeBotFromBlacklist(address[] calldata remove) external {
        if (msg.sender != manager) revert Unauthorized();
        for (uint i = 0; i < remove.length; i++) {
            blacklist[remove[i]] = false;
        }
        emit BlacklistRemoved(remove);
    }

    function setConfig(
        address _manager,
        address _gateway,
        uint _minRound
    ) external {
        if (msg.sender != manager) revert Unauthorized();
        gateway = _gateway;
        manager = _manager;
        minRound = _minRound;
        emit ConfigChanged(gateway, manager, minRound);
    }
}
