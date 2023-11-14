// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import 'forge-std/Script.sol';
import {Skin, Background, Helpers} from 'contracts/libraries/svgs/Profile/Helpers.sol';
import {Face} from 'contracts/libraries/svgs/Profile/Face.sol';
import {Legs} from 'contracts/libraries/svgs/Profile/Legs.sol';
import {Shoes} from 'contracts/libraries/svgs/Profile/Shoes.sol';
import {Body} from 'contracts/libraries/svgs/Profile/Body.sol';
import {Hands} from 'contracts/libraries/svgs/Profile/Hands.sol';
import {Logo} from 'contracts/libraries/svgs/Profile/Logo.sol';
import {Headwear} from 'contracts/libraries/svgs/Profile/Headwear.sol';

import {ProfileSVG} from 'contracts/libraries/svgs/Profile/ProfileSVG.sol';

contract ProfileNFT {
    function tryProfile(uint256 profileId) external pure returns (string memory) {
        return ProfileSVG.getProfileSVG(profileId);
    }

    function tryWithSeed(uint256 seed, bool isGold) external pure returns (string memory) {
        return ProfileSVG._getSVG(seed, isGold);
    }
}

contract ProfileSVGGen is Script {
    ProfileNFT profileNFT;
    string constant dir = 'svgs/';

    function setUp() public {
        profileNFT = new ProfileNFT();
    }

    function _tryElement(uint256 maxColors, Helpers.ComponentBytes componentByte, string memory elementName) internal {
        for (uint8 i = 0; i <= maxColors + 1; i++) {
            uint256 seed = setColor(i, componentByte);
            console.logBytes32(bytes32(seed));
            string memory result = profileNFT.tryWithSeed(seed, i == maxColors + 1);
            vm.writeFile(
                string.concat(
                    dir,
                    elementName,
                    '/',
                    elementName,
                    '_',
                    i == maxColors + 1 ? 'gold' : vm.toString(i),
                    '.svg'
                ),
                result
            );
        }
    }

    function tryBackgrounds() public {
        _tryElement(uint256(type(Background.BackgroundColors).max), Helpers.ComponentBytes.BACKGROUND, 'background');
    }

    function trySkins() public {
        _tryElement(uint256(type(Skin.SkinColors).max), Helpers.ComponentBytes.SKIN, 'skin');
    }

    function tryLegs() public {
        _tryElement(uint256(type(Legs.LegColors).max), Helpers.ComponentBytes.LEGS, 'legs');
    }

    function tryShoes() public {
        _tryElement(uint256(type(Shoes.ShoeColors).max), Helpers.ComponentBytes.SHOES, 'shoes');
    }

    function tryFaces() public {
        for (uint8 v = 0; v <= uint8(type(Face.FaceVariants).max); v++) {
            for (uint8 c = 0; c <= uint8(type(Face.FaceColors).max) + 1; c++) {
                uint256 seed = setVariant(v, Helpers.ComponentBytes.FACE) + setColor(c, Helpers.ComponentBytes.FACE);
                string memory result = profileNFT.tryWithSeed(seed, c == uint8(type(Face.FaceColors).max) + 1);
                vm.writeFile(
                    string.concat(
                        dir,
                        'faces/face_',
                        vm.toString(v),
                        '_',
                        c == uint8(type(Face.FaceColors).max) + 1 ? 'gold' : vm.toString(c),
                        '.svg'
                    ),
                    result
                );
            }
        }
    }

    function tryHandsAndBody() public {
        for (uint8 v = 0; v <= uint8(type(Body.BodyVariants).max); v++) {
            for (uint8 c = 0; c <= uint8(type(Body.BodyColors).max); c++) {
                for (uint8 h = 0; h <= uint8(type(Hands.HandsVariants).max); h++) {
                    for (uint8 hc = 0; hc <= uint8(type(Skin.SkinColors).max) + 1; hc++) {
                        uint256 seed = setVariant(v, Helpers.ComponentBytes.BODY) +
                            setColor(c, Helpers.ComponentBytes.BODY) +
                            setVariant(h, Helpers.ComponentBytes.HANDS) +
                            setColor(hc, Helpers.ComponentBytes.SKIN);
                        string memory result = profileNFT.tryWithSeed(seed, hc == uint8(type(Skin.SkinColors).max) + 1);
                        vm.writeFile(
                            string.concat(
                                dir,
                                'body/body_b',
                                vm.toString(v),
                                '_bc',
                                vm.toString(c),
                                '_h',
                                vm.toString(h),
                                '_hc',
                                hc == uint8(type(Skin.SkinColors).max) + 1 ? 'gold' : vm.toString(hc),
                                '.svg'
                            ),
                            result
                        );
                    }
                }
            }
        }
    }

    function tryLogoWithBody() public {
        for (uint8 b = 0; b <= uint8(type(Body.BodyVariants).max); b++) {
            for (uint8 bc = 0; bc <= uint8(type(Body.BodyColors).max); bc++) {
                for (uint8 l = 0; l <= uint8(type(Logo.LogoVariants).max); l++) {
                    for (uint8 lc = 0; lc <= uint8(type(Logo.LogoColors).max); lc++) {
                        uint256 seed = setVariant(b, Helpers.ComponentBytes.BODY) +
                            setColor(bc, Helpers.ComponentBytes.BODY) +
                            setVariant(l, Helpers.ComponentBytes.LOGO) +
                            setColor(lc, Helpers.ComponentBytes.LOGO);
                        string memory result = profileNFT.tryWithSeed(seed, false);
                        vm.writeFile(
                            string.concat(
                                dir,
                                'logo/logo_b',
                                vm.toString(b),
                                '_bc',
                                vm.toString(bc),
                                '_l',
                                vm.toString(l),
                                '_lc',
                                vm.toString(lc),
                                '.svg'
                            ),
                            result
                        );
                    }
                }
            }
        }
    }

    function tryHeadwear() public {
        for (uint8 v = 0; v <= uint8(type(Headwear.HeadwearVariants).max); v++) {
            for (uint8 c = 0; c <= 7; c++) {
                uint256 seed = setVariant(v, Helpers.ComponentBytes.HEADWEAR) +
                    setColor(c, Helpers.ComponentBytes.HEADWEAR);
                string memory result = profileNFT.tryWithSeed(seed, false);
                vm.writeFile(
                    string.concat(dir, 'headwear/headwear_v', vm.toString(v), '_c', vm.toString(c), '.svg'),
                    result
                );
            }
        }
        for (uint8 v = 0; v <= uint8(type(Headwear.HeadwearVariants).max); v++) {
            for (uint8 c = 0; c <= 7; c++) {
                uint256 seed = setVariant(v, Helpers.ComponentBytes.HEADWEAR) +
                    setColor(c, Helpers.ComponentBytes.HEADWEAR);
                string memory result = profileNFT.tryWithSeed(seed, true);
                vm.writeFile(
                    string.concat(dir, 'headwear/headwear_v', vm.toString(v), '_c', vm.toString(c), '_onGold.svg'),
                    result
                );
            }
        }
        // Icecream
        for (uint8 c = 0; c <= 4; c++) {
            uint256 seed = setVariant(69, Helpers.ComponentBytes.HEADWEAR) +
                setColor(c, Helpers.ComponentBytes.HEADWEAR);
            string memory result = profileNFT.tryWithSeed(seed, false);
            vm.writeFile(string.concat(dir, 'headwear/headwear_v69', '_c', vm.toString(c), '.svg'), result);
        }
        for (uint8 c = 0; c <= 4; c++) {
            uint256 seed = setVariant(69, Helpers.ComponentBytes.HEADWEAR) +
                setColor(c, Helpers.ComponentBytes.HEADWEAR);
            string memory result = profileNFT.tryWithSeed(seed, true);
            vm.writeFile(string.concat(dir, 'headwear/headwear_v69', '_c', vm.toString(c), '_onGold.svg'), result);
        }
    }

    function tryGoldProfiles1() public {
        uint256 i;
        for (i = 1; i < 10; i++) {
            string memory result = profileNFT.tryProfile(i);
            vm.writeFile(string.concat(dir, 'profiles_gold/profile_', vm.toString(i), '.svg'), result);
        }
    }

    function tryHowManyHaveIcecream() public view {
        console.log('How many have icecream?');
        uint256 count;
        for (uint256 i = 1; i < 130000; i++) {
            uint256 seed = uint256(keccak256(abi.encodePacked(i)));
            if (Helpers.getVariant(seed, Helpers.ComponentBytes.HEADWEAR) == 69) {
                console.log(i);
                count++;
            }
        }
        console.log('Total: ', count);
    }

    function tryProfiles() public {
        uint i = 1001;
        string memory result = profileNFT.tryProfile(i);
        vm.writeFile(string.concat(dir, 'profiles/profile_', vm.toString(i), '.svg'), result);

        for (i = 35000; i < 35010; i++) {
            result = profileNFT.tryProfile(i);
            vm.writeFile(string.concat(dir, 'profiles/profile_', vm.toString(i), '.svg'), result);
        }
    }

    function tryFuzzProfiles() public {
        for (uint256 i = 1; i < 10; i++) {
            uint256 profileId = uint256(keccak256(abi.encode(i))) % 10000000;
            string memory result = profileNFT.tryProfile(profileId);
            vm.writeFile(string.concat(dir, 'profiles_fuzz/profile_', vm.toString(profileId), '.svg'), result);
        }
    }

    // We take variants from the right bytes of the seed
    function setVariant(uint256 newByte, Helpers.ComponentBytes componentByte) internal pure returns (uint256) {
        return newByte << (uint8(componentByte) * 8);
    }

    // We take colors from the left bytes of the seed
    function setColor(uint256 newByte, Helpers.ComponentBytes componentByte) internal pure returns (uint256) {
        return newByte << ((31 - uint8(componentByte)) * 8);
    }

    function run() external {
        tryBackgrounds();
        trySkins();
        tryLegs();
        tryShoes();
        tryFaces();
        tryHandsAndBody();
        tryLogoWithBody();
        tryHeadwear();
        tryGoldProfiles1();
        tryProfiles();
        tryFuzzProfiles();
    }
}
