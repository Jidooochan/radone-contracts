// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DrandCommonLib {
    /// The chain hash serves as a drand network identifier.
    /// See <https://drand.love/developer/> and <https://drand.cloudflare.com/info>
    string public constant DRAND_CHAIN_HASH =
        "dbd506d6ef76e5f386f41c651dcb808c5bcbd75471cc4eafa3f4df7ad4e4c493";

    /// https://api3.drand.sh/dbd506d6ef76e5f386f41c651dcb808c5bcbd75471cc4eafa3f4df7ad4e4c493/info
    uint public constant DRAND_GENESIS = 1677685200;
    uint public constant DRAND_ROUND_LENGTH = 3 seconds;

    /// The pubkey for fastnet (<https://api3.drand.sh/dbd506d6ef76e5f386f41c651dcb808c5bcbd75471cc4eafa3f4df7ad4e4c493/info>)
    function getDrandMainnet2Pubkey() internal pure returns (uint8[96] memory) {
        return [
            160,
            184,
            98,
            167,
            82,
            127,
            238,
            58,
            115,
            27,
            203,
            89,
            40,
            10,
            182,
            171,
            214,
            45,
            92,
            11,
            110,
            160,
            61,
            196,
            221,
            246,
            97,
            47,
            223,
            201,
            208,
            31,
            1,
            195,
            21,
            66,
            84,
            23,
            113,
            144,
            52,
            117,
            235,
            30,
            198,
            97,
            95,
            141,
            13,
            240,
            184,
            182,
            220,
            227,
            133,
            129,
            29,
            109,
            207,
            140,
            190,
            251,
            135,
            89,
            229,
            230,
            22,
            163,
            223,
            208,
            84,
            201,
            40,
            148,
            7,
            102,
            217,
            165,
            185,
            219,
            145,
            227,
            182,
            151,
            229,
            215,
            10,
            151,
            81,
            129,
            224,
            7,
            248,
            127,
            202,
            94
        ];
    }

    function getTimeOfRound(uint round) public pure returns (uint) {
        return DRAND_GENESIS + DRAND_ROUND_LENGTH * (round - 1);
    }

    function roundAfter(uint base) internal pure returns (uint) {
        if (base < DRAND_GENESIS) {
            return 1;
        } else {
            uint periodsSinceGenesis = (base - DRAND_GENESIS) /
                DRAND_ROUND_LENGTH;
            uint nextPeriodIndex = periodsSinceGenesis + 1;
            return nextPeriodIndex + 1;
        }
    }
}
