// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {DataTypes} from '../libraries/DataTypes.sol';

/**
 * @title ILensHub
 * @author Lens Protocol
 *
 * @notice This is the interface for the LensHub contract, the main entry point for the Lens Protocol.
 * You'll find all the events and external functions, as well as the reasoning behind them here.
 */
interface ILensHub {
    /**
     * @notice Initializes the LensHub NFT, setting the initial governance address as well as the name and symbol in
     * the LensNFTBase contract.
     *
     * @param name The name to set for the hub NFT.
     * @param symbol The symbol to set for the hub NFT.
     * @param newGovernance The governance address to set.
     */
    function initialize(
        string calldata name,
        string calldata symbol,
        address newGovernance
    ) external;

    /**
     * @notice Sets the privileged governance role. This function can only be called by the current governance
     * address.
     *
     * @param newGovernance The new governance address to set.
     */
    function setGovernance(address newGovernance) external;

    /**
     * @notice Sets the emergency admin, which is a permissioned role able to set the protocol state. This function
     * can only be called by the governance address.
     *
     * @param newEmergencyAdmin The new emergency admin address to set.
     */
    function setEmergencyAdmin(address newEmergencyAdmin) external;

    /**
     * @notice Sets the protocol state to either a global pause, a publishing pause or an unpaused state. This function
     * can only be called by the governance address or the emergency admin address.
     *
     * Note that this reverts if the emergency admin calls it if:
     *      1. The emergency admin is attempting to unpause.
     *      2. The emergency admin is calling while the protocol is already paused.
     *
     * @param newState The state to set, as a member of the ProtocolState enum.
     */
    function setState(DataTypes.ProtocolState newState) external;

    /**
     * @notice Adds or removes a profile creator from the whitelist. This function can only be called by the current
     * governance address.
     *
     * @param profileCreator The profile creator address to add or remove from the whitelist.
     * @param whitelist Whether or not the profile creator should be whitelisted.
     */
    function whitelistProfileCreator(address profileCreator, bool whitelist) external;

    /**
     * @notice Adds or removes a follow module from the whitelist. This function can only be called by the current
     * governance address.
     *
     * @param followModule The follow module contract address to add or remove from the whitelist.
     * @param whitelist Whether or not the follow module should be whitelisted.
     */
    function whitelistFollowModule(address followModule, bool whitelist) external;

    /**
     * @notice Adds or removes a reference module from the whitelist. This function can only be called by the current
     * governance address.
     *
     * @param referenceModule The reference module contract to add or remove from the whitelist.
     * @param whitelist Whether or not the reference module should be whitelisted.
     */
    function whitelistReferenceModule(address referenceModule, bool whitelist) external;

    /**
     * @notice Adds or removes a collect module from the whitelist. This function can only be called by the current
     * governance address.
     *
     * @param collectModule The collect module contract address to add or remove from the whitelist.
     * @param whitelist Whether or not the collect module should be whitelisted.
     */
    function whitelistCollectModule(address collectModule, bool whitelist) external;

    /**
     * @notice Creates a profile with the specified parameters, minting a profile NFT to the given recipient. This
     * function must be called by a whitelisted profile creator.
     *
     * @param vars A CreateProfileData struct containing the following params:
     *      to: The address receiving the profile.
     *      imageURI: The URI to set for the profile image.
     *      followModule: The follow module to use, can be the zero address.
     *      followModuleInitData: The follow module initialization data, if any.
     */
    function createProfile(DataTypes.CreateProfileData calldata vars) external returns (uint256);

    /**
     * @notice Sets the mapping between wallet and its main profile identity. Must be called either by the wallet or a
     * delegated executor.
     *
     * @param onBehalfOf The address to set the default profile on behalf of.
     * @param profileId The token ID of the profile to set as the main profile identity.
     */
    function setDefaultProfile(address onBehalfOf, uint256 profileId) external;

    /**
     * @notice Sets the mapping between wallet and its main profile identity via signature with the specified parameters. The
     * signer must either be the profile owner or a delegated executor.
     *
     * @param vars A SetDefaultProfileWithSigData struct, including the regular parameters and an EIP712Signature struct.
     */
    function setDefaultProfileWithSig(DataTypes.SetDefaultProfileWithSigData calldata vars)
        external;

    /**
     * @notice Sets the metadata URI for the given profile. Must be called either from the profile owner, a delegated
     * executor, or the profile's dispatcher.
     *
     * @param profileId The token ID of the profile to set the metadata URI for.
     * @param metadataURI The metadata URI to set for the given profile.
     */
    function setProfileMetadataURI(uint256 profileId, string calldata metadataURI) external;

    /**
     * @notice Sets the metadata URI via signature for the given profile with the specified parameters. The signer must
     * either be the profile owner or a delegated executor.
     *
     * @param vars A SetProfileMetadataURIWithSigData struct, including the regular parameters and an EIP712Signature struct.
     */
    function setProfileMetadataURIWithSig(DataTypes.SetProfileMetadataURIWithSigData calldata vars)
        external;

    /**
     * @notice Sets the follow module for the given profile. Must be called by the profile owner.
     *
     * @param profileId The token ID of the profile to set the follow module for.
     * @param followModule The follow module to set for the given profile, must be whitelisted.
     * @param followModuleInitData The data to be passed to the follow module for initialization.
     */
    function setFollowModule(
        uint256 profileId,
        address followModule,
        bytes calldata followModuleInitData
    ) external;

    /**
     * @notice Sets the follow module via signature for the given profile with the specified parameters. The signer must
     * either be the profile owner or a delegated executor.
     *
     * @param vars A SetFollowModuleWithSigData struct, including the regular parameters and an EIP712Signature struct.
     */
    function setFollowModuleWithSig(DataTypes.SetFollowModuleWithSigData calldata vars) external;

    /**
     * @notice Sets a profile's dispatcher, giving that dispatcher rights to publish to that profile.
     *
     * @param profileId The token ID of the profile of the profile to set the dispatcher for.
     * @param dispatcher The dispatcher address to set for the given profile ID.
     */
    function setDispatcher(uint256 profileId, address dispatcher) external;

    /**
     * @notice Sets a profile's dispatcher via signature with the specified parameters.
     *
     * @param vars A SetDispatcherWithSigData struct, including the regular parameters and an EIP712Signature struct.
     */
    function setDispatcherWithSig(DataTypes.SetDispatcherWithSigData calldata vars) external;

    /**
     * @notice Sets the approval for a delegated executor to act on behalf of the caller.
     *
     * @param executor The executor to set the approval for.
     * @param approved The approval to set.
     */
    function setDelegatedExecutorApproval(address executor, bool approved) external;

    /**
     * @notice Sets the approval for a delegated executor to act on behalf of a given signer.
     *
     * @param vars A SetDelegatedExecutorApprovalWithSigData struct, including the regular parameters and an EIP712Signature
     * struct.
     */
    function setDelegatedExecutorApprovalWithSig(
        DataTypes.SetDelegatedExecutorApprovalWithSigData calldata vars
    ) external;

    /**
     * @notice Sets a profile's image URI, which is reflected in the `tokenURI()` function.
     *
     * @param profileId The token ID of the profile of the profile to set the URI for.
     * @param imageURI The URI to set for the given profile.
     */
    function setProfileImageURI(uint256 profileId, string calldata imageURI) external;

    /**
     * @notice Sets the image URI via signature for the given profile with the specified parameters. The signer must
     * either be the profile owner or a delegated executor.
     *
     * @param vars A SetProfileImageURIWithSigData struct, including the regular parameters and an EIP712Signature struct.
     */
    function setProfileImageURIWithSig(DataTypes.SetProfileImageURIWithSigData calldata vars)
        external;

    /**
     * @notice Sets a followNFT URI for a given profile's follow NFT.
     *
     * @param profileId The token ID of the profile for which to set the followNFT URI.
     * @param followNFTURI The follow NFT URI to set.
     */
    function setFollowNFTURI(uint256 profileId, string calldata followNFTURI) external;

    /**
     * @notice Sets a followNFT URI via signature for the given profile with the specified parameters. The signer must
     * either be the profile owner or a delegated executor.
     *
     * @param vars A SetFollowNFTURIWithSigData struct, including the regular parameters and an EIP712Signature struct.
     */
    function setFollowNFTURIWithSig(DataTypes.SetFollowNFTURIWithSigData calldata vars) external;

    /**
     * @notice Publishes a post to a given profile, must be called by the profile owner.
     *
     * @param vars A PostData struct containing the needed parameters.
     *
     * @return uint256 An integer representing the post's publication ID.
     */
    function post(DataTypes.PostData calldata vars) external returns (uint256);

    /**
     * @notice Publishes a post to a given profile via signature with the specified parameters. The signer must
     * either be the profile owner or a delegated executor.
     *
     * @param vars A PostWithSigData struct containing the regular parameters and an EIP712Signature struct.
     *
     * @return uint256 An integer representing the post's publication ID.
     */
    function postWithSig(DataTypes.PostWithSigData calldata vars) external returns (uint256);

    /**
     * @notice Publishes a comment to a given profile, must be called by the profile owner.
     *
     * @param vars A CommentData struct containing the needed parameters.
     *
     * @return uint256 An integer representing the comment's publication ID.
     */
    function comment(DataTypes.CommentData calldata vars) external returns (uint256);

    /**
     * @notice Publishes a comment to a given profile via signature with the specified parameters. The signer must
     * either be the profile owner or a delegated executor.
     *
     * @param vars A CommentWithSigData struct containing the regular parameters and an EIP712Signature struct.
     *
     * @return uint256 An integer representing the comment's publication ID.
     */
    function commentWithSig(DataTypes.CommentWithSigData calldata vars) external returns (uint256);

    /**
     * @notice Publishes a mirror to a given profile, must be called by the profile owner.
     *
     * @param vars A MirrorData struct containing the necessary parameters.
     *
     * @return uint256 An integer representing the mirror's publication ID.
     */
    function mirror(DataTypes.MirrorData calldata vars) external returns (uint256);

    /**
     * @notice Publishes a mirror to a given profile via signature with the specified parameters. The signer must
     * either be the profile owner or a delegated executor.
     *
     * @param vars A MirrorWithSigData struct containing the regular parameters and an EIP712Signature struct.
     *
     * @return uint256 An integer representing the mirror's publication ID.
     */
    function mirrorWithSig(DataTypes.MirrorWithSigData calldata vars) external returns (uint256);

    /**
     * @notice Follows the given profiles, executing each profile's follow module logic (if any).
     *
     * @dev Both the `idsOfProfilesToFollow`, `followTokenIds`, and `datas` arrays must be of the same length,
     * regardless if the profiles do not have a follow module set.
     *
     * @param followerProfileId The ID of the profile the follows are being executed for.
     * @param idsOfProfilesToFollow The array of IDs of profiles to follow.
     * @param followTokenIds The array of follow token IDs to use for each follow.
     * @param datas The arbitrary data array to pass to the follow module for each profile if needed.
     *
     * @return uint256[] An array follow token IDs used for each follow operation.
     */
    function follow(
        uint256 followerProfileId,
        uint256[] calldata idsOfProfilesToFollow,
        uint256[] calldata followTokenIds,
        bytes[] calldata datas
    ) external returns (uint256[] memory);

    /**
     * @notice Follows the given profiles via signature with the specified parameters. The signer must either be the
     * follower or a delegated executor.
     *
     * @param vars A FollowWithSigData struct containing the regular parameters as well as the signing follower's
     * address and an EIP712Signature struct.
     *
     * @return uint256[] An array follow token IDs used for each follow operation.
     */
    function followWithSig(DataTypes.FollowWithSigData calldata vars)
        external
        returns (uint256[] memory);

    /**
     * @notice Unfollows the given profiles.
     *
     * @param unfollowerProfileId The ID of the profile the unfollows are being executed for.
     * @param idsOfProfilesToUnfollow The array of IDs of profiles to unfollow.
     */
    function unfollow(uint256 unfollowerProfileId, uint256[] calldata idsOfProfilesToUnfollow)
        external;

    /**
     * @notice Unfollows the given profiles via signature with the specified parameters. The signer must either be the
     * unfollower or a delegated executor.
     *
     * @param vars An UnollowWithSigData struct containing the regular parameters as well as the signing unfollower's
     * address and an EIP712Signature struct.
     */
    function unfollowWithSig(DataTypes.UnfollowWithSigData calldata vars) external;

    /**
     * @notice Sets the block status for the given profiles. Changing a profile's block status to `true` (i.e. blocked),
     * when it was following, will make it unfollow.
     *
     * @dev Both the `idsOfProfilesToSetBlockStatus` and `blockStatus` arrays must be of the same length.
     *
     * @param byProfileId The ID of the profile the block status sets are being executed for.
     * @param idsOfProfilesToSetBlockStatus The array of IDs of profiles to set block status.
     * @param blockStatus The array of block status to use for each setting.
     */
    function setBlockStatus(
        uint256 byProfileId,
        uint256[] calldata idsOfProfilesToSetBlockStatus,
        bool[] calldata blockStatus
    ) external;

    /**
     * @notice Blocks the given profiles via signature with the specified parameters. The signer must either be the
     * blocker or a delegated executor.
     *
     * @param vars An SetBlockStatusWithSigData struct containing the regular parameters as well as the signing
     * blocker's address and an EIP712Signature struct.
     */
    function setBlockStatusWithSig(DataTypes.SetBlockStatusWithSigData calldata vars) external;

    /**
     * @notice Collects a given publication, executing collect module logic and minting a collectNFT to the caller.
     *
     * @param collectorProfileId The ID of the profile the collect is being executed from.
     * @param publisherProfileId The token ID of the profile that published the publication to collect.
     * @param pubId The publication to collect's publication ID.
     * @param data The arbitrary data to pass to the collect module if needed.
     *
     * @return uint256 An integer representing the minted token ID.
     */
    function collect(
        uint256 collectorProfileId,
        uint256 publisherProfileId,
        uint256 pubId,
        bytes calldata data
    ) external returns (uint256);

    /**
     * @notice Collects a given publication via signature with the specified parameters. The signer must either be the collector
     * or a delegated executor.
     *
     * @param vars A CollectWithSigData struct containing the regular parameters as well as the collector's address and
     * an EIP712Signature struct.
     *
     * @return uint256 An integer representing the minted token ID.
     */
    function collectWithSig(DataTypes.CollectWithSigData calldata vars) external returns (uint256);

    /**
     * @dev Helper function to emit a detailed followNFT transfer event from the hub, to be consumed by indexers to
     * track followNFT transfers.
     *
     * @param profileId The token ID of the profile associated with the followNFT being transferred.
     * @param followNFTId The followNFT being transferred's token ID.
     * @param from The address the followNFT is being transferred from.
     * @param to The address the followNFT is being transferred to.
     */
    function emitFollowNFTTransferEvent(
        uint256 profileId,
        uint256 followNFTId,
        address from,
        address to
    ) external;

    /**
     * @dev Helper function to emit a detailed collectNFT transfer event from the hub, to be consumed by indexers to
     * track collectNFT transfers.
     *
     * @param profileId The token ID of the profile associated with the collect NFT being transferred.
     * @param pubId The publication ID associated with the collect NFT being transferred.
     * @param collectNFTId The collectNFT being transferred's token ID.
     * @param from The address the collectNFT is being transferred from.
     * @param to The address the collectNFT is being transferred to.
     */
    function emitCollectNFTTransferEvent(
        uint256 profileId,
        uint256 pubId,
        uint256 collectNFTId,
        address from,
        address to
    ) external;

    /**
     * @dev Helper function to emit an `Unfollowed` event from the hub, to be consumed by indexers to track unfollows.
     *
     * @param unfollowerProfileId The ID of the profile that executed the unfollow.
     * @param idOfProfileUnfollowed The ID of the profile that was unfollowed.
     */
    function emitUnfollowedEvent(uint256 unfollowerProfileId, uint256 idOfProfileUnfollowed)
        external;

    /// ************************
    /// *****VIEW FUNCTIONS*****
    /// ************************

    /**
     * @notice Returns whether  or not `followerProfileId` is following `followedProfileId`.
     *
     * @param followerProfileId The ID of the profile whose following state should be queried.
     * @param followedProfileId The ID of the profile whose followed state should be queried.
     *
     * @return bool True if `followerProfileId` is following `followedProfileId`, false otherwise.
     */
    function isFollowing(uint256 followerProfileId, uint256 followedProfileId)
        external
        view
        returns (bool);

    /**
     * @notice Returns whether or not a profile creator is whitelisted.
     *
     * @param profileCreator The address of the profile creator to check.
     *
     * @return bool True if the profile creator is whitelisted, false otherwise.
     */
    function isProfileCreatorWhitelisted(address profileCreator) external view returns (bool);

    /**
     * @notice Returns whether or not a follow module is whitelisted.
     *
     * @param followModule The address of the follow module to check.
     *
     * @return bool True if the the follow module is whitelisted, false otherwise.
     */
    function isFollowModuleWhitelisted(address followModule) external view returns (bool);

    /**
     * @notice Returns whether or not a reference module is whitelisted.
     *
     * @param referenceModule The address of the reference module to check.
     *
     * @return bool True if the the reference module is whitelisted, false otherwise.
     */
    function isReferenceModuleWhitelisted(address referenceModule) external view returns (bool);

    /**
     * @notice Returns whether or not a collect module is whitelisted.
     *
     * @param collectModule The address of the collect module to check.
     *
     * @return bool True if the the collect module is whitelisted, false otherwise.
     */
    function isCollectModuleWhitelisted(address collectModule) external view returns (bool);

    /**
     * @notice Returns the currently configured governance address.
     *
     * @return address The address of the currently configured governance.
     */
    function getGovernance() external view returns (address);

    /**
     * @notice Returns whether the given delegated executor is approved to act on behalf of the given
     * wallet.
     *
     * @param wallet The wallet to check the delegated executor approval for.
     * @param executor The executor to query the delegated executor approval for.
     *
     * @return bool True if the executor is approved as a delegated executor to act on behalf of the wallet,
     * false otherwise.
     */
    function isDelegatedExecutorApproved(address wallet, address executor)
        external
        view
        returns (bool);

    /**
     * @notice Returns whether `profile` is blocked by `byProfile`.
     *
     * @param profileId The ID of the profile whose blocked status should be queried.
     * @param byProfileId The ID of the profile whose blocker status should be queried.
     *
     * @return bool True if `profileId` is blocked by `byProfileId`, false otherwise.
     */
    function isBlocked(uint256 profileId, uint256 byProfileId) external view returns (bool);

    /**
     * @notice Returns the default profile for a given wallet address
     *
     * @param wallet The address to find the default mapping
     *
     * @return uint256 The default profile id, which will be 0 if not mapped.
     */
    function getDefaultProfile(address wallet) external view returns (uint256);

    /**
     * @notice Returns the metadata URI for a given profile
     *
     * @param profileId The token ID of the profile to query the metadata URI for.
     *
     * @return string The metadata URI associated with the given profile.
     */
    function getProfileMetadataURI(uint256 profileId) external view returns (string memory);

    /**
     * @notice Returns the dispatcher for a given profile.
     *
     * @param profileId The token ID of the profile to query the dispatcher for.
     *
     * @return address The dispatcher address associated with the given profile.
     */
    function getDispatcher(uint256 profileId) external view returns (address);

    /**
     * @notice Returns the publication count for a given profile.
     *
     * @param profileId The token ID of the profile to query the publication count for.
     *
     * @return uint256 The number of publications associated with the given profile.
     */
    function getPubCount(uint256 profileId) external view returns (uint256);

    /**
     * @notice Returns the image URI for a given profile
     *
     * @param profileId The token ID of the profile to query the image URI for.
     *
     * @return string The image URI associated with the given profile.
     */
    function getProfileImageURI(uint256 profileId) external view returns (string memory);

    /**
     * @notice Returns the followNFT associated with a given profile, if any.
     *
     * @param profileId The token ID of the profile to query the followNFT for.
     *
     * @return address The followNFT associated with the given profile.
     */
    function getFollowNFT(uint256 profileId) external view returns (address);

    /**
     * @notice Returns the followNFT URI associated with a given profile.
     *
     * @param profileId The token ID of the profile to query the followNFT URI for.
     *
     * @return string The followNFT URI associated with the given profile.
     */
    function getFollowNFTURI(uint256 profileId) external view returns (string memory);

    /**
     * @notice Returns the collectNFT associated with a given publication, if any.
     *
     * @param profileId The token ID of the profile that published the publication to query.
     * @param pubId The publication ID of the publication to query.
     *
     * @return address The address of the collectNFT associated with the given publication.
     */
    function getCollectNFT(uint256 profileId, uint256 pubId) external view returns (address);

    /**
     * @notice Returns the follow module associated witha  given profile, if any.
     *
     * @param profileId The token ID of the profile to query the follow module for.
     *
     * @return address The address of the follow module associated with the given profile.
     */
    function getFollowModule(uint256 profileId) external view returns (address);

    /**
     * @notice Returns the collect module associated with a given publication.
     *
     * @param profileId The token ID of the profile that published the publication to query.
     * @param pubId The publication ID of the publication to query.
     *
     * @return address The address of the collect module associated with the queried publication.
     */
    function getCollectModule(uint256 profileId, uint256 pubId) external view returns (address);

    /**
     * @notice Returns the reference module associated witha  given profile, if any.
     *
     * @param profileId The token ID of the profile that published the publication to querythe reference module for.
     * @param pubId The publication ID of the publication to query the reference module for.
     *
     * @return address The address of the reference module associated with the given profile.
     */
    function getReferenceModule(uint256 profileId, uint256 pubId) external view returns (address);

    /**
     * @notice Returns the publication pointer (profileId & pubId) associated with a given publication.
     *
     * @param profileId The token ID of the profile that published the publication to query the pointer for.
     * @param pubId The publication ID of the publication to query the pointer for.
     *
     * @return tuple First, the profile ID of the profile the current publication is pointing to, second, the
     * publication ID of the publication the current publication is pointing to.
     */
    function getPubPointer(uint256 profileId, uint256 pubId)
        external
        view
        returns (uint256, uint256);

    /**
     * @notice Returns the URI associated with a given publication.
     *
     * @param profileId The token ID of the profile that published the publication to query.
     * @param pubId The publication ID of the publication to query.
     *
     * @return string The URI associated with a given publication.
     */
    function getContentURI(uint256 profileId, uint256 pubId) external view returns (string memory);

    /**
     * @notice Returns the full profile struct associated with a given profile token ID.
     *
     * @param profileId The token ID of the profile to query.
     *
     * @return ProfileStruct The profile struct of the given profile.
     */
    function getProfile(uint256 profileId) external view returns (DataTypes.ProfileStruct memory);

    /**
     * @notice Returns the full publication struct for a given publication.
     *
     * @param profileId The token ID of the profile that published the publication to query.
     * @param pubId The publication ID of the publication to query.
     *
     * @return PublicationStruct The publication struct associated with the queried publication.
     */
    function getPub(uint256 profileId, uint256 pubId)
        external
        view
        returns (DataTypes.PublicationStruct memory);

    /**
     * @notice Returns the publication type associated with a given publication.
     *
     * @param profileId The token ID of the profile that published the publication to query.
     * @param pubId The publication ID of the publication to query.
     *
     * @return PubType The publication type, as a member of an enum (either "post," "comment" or "mirror").
     */
    function getPubType(uint256 profileId, uint256 pubId) external view returns (DataTypes.PubType);

    /**
     * @notice Returns the follow NFT implementation address.
     *
     * @return address The follow NFT implementation address.
     */
    function getFollowNFTImpl() external view returns (address);

    /**
     * @notice Returns the collect NFT implementation address.
     *
     * @return address The collect NFT implementation address.
     */
    function getCollectNFTImpl() external view returns (address);
}
