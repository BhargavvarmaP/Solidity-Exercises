//SPDX-License-Identifier:MIT
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeedTest {
  AggregatorV3Interface public pricefeed;
  constructor() {
    pricefeed  = AggregatorV3Interface(0x99Af0CF37d1C6b9Bdfe33cc0A89C00D97D3c42F4);
  }
  function getPrice() public view returns(int) {
    (uint80 roundID,int price,uint startedAt,uint timestamp,uint answerinRound) = pricefeed.latestRoundData();
    return price;
  }
}