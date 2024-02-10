/**
 * @title VestingWallet
 * @dev This contract handles the vesting of Eth and ERC20 tokens for a given beneficiary. Custody of multiple tokens
 * can be given to this contract, which will release the token to the beneficiary following a given vesting schedule.
 * The vesting schedule is customizable through the {vestedAmount} function.
 *
 * Any token transferred to this contract will follow the vesting schedule as if they were locked from the beginning.
 * Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly)
 * be immediately releasable.
 */
 interface IVestingWallet {
  event EtherReleased(uint256 amount);
  event ERC20Released(address indexed token, uint256 amount);

  /**
   * @dev Getter for the beneficiary address.
   */
  function beneficiary() external view returns (address);

  /**
   * @dev Getter for the start timestamp.
   */
  function start() external view returns (uint256);

  /**
   * @dev Getter for the vesting duration.
   */
  function duration() external view returns (uint256);

  /**
   * @dev Amount of eth already released
   */
  function released() external view returns (uint256);

  /**
   * @dev Amount of token already released
   */
  function released(address token) external view returns (uint256);

  /**
   * @dev Getter for the amount of releasable eth.
   */
  function releasable() external view returns (uint256);

  /**
   * @dev Getter for the amount of releasable `token` tokens. `token` should be the address of an
   * IERC20 contract.
   */
  function releasable(address token) external view returns (uint256);

  /**
   * @dev Release the native token (ether) that have already vested.
   *
   * Emits a {EtherReleased} event.
   */
  function release() external;

  /**
   * @dev Release the tokens that have already vested.
   *
   * Emits a {ERC20Released} event.
   */
  function release(address token) external;

  /**
   * @dev Calculates the amount of ether that has already vested. Default implementation is a linear vesting curve.
   */
  function vestedAmount(uint64 timestamp) external view returns (uint256);

  /**
   * @dev Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
   */
  function vestedAmount(address token, uint64 timestamp) external view returns (uint256);
}
