import { useState } from "react";
import { ethers } from "ethers";
import { contract, signer } from "../App";
//import { contract } from "./Home";
//import { signer } from "./Home";

function Market() {
  const [trades, setTrades] = useState([]);

  const getActiveTrades = async () => {
    //console.log(contract);
    const trades = await contract.getActiveTrades();
    console.log("lungime ", trades.length);
    setTrades(trades);
    for (var i = 0; i < trades.length; i++)
      console.log(parseInt(trades[i].index));
  };

  const openTrade = async (tokenId, price) => {
    try {
      await contract.sellTrade(tokenId, price);
      console.log("Trade published!");
    } catch (err) {
      console.log(err);
    }
  };

  const executeTrade = async (tr) => {
    try {
      //await contract.executeTrade(tradeId);

      //const connection = contract.connect(signer);
      //const addr = connection.address;
      await contract.buyTrade(tradeId, {
        value: ethers.utils.parseEther(parseInt(tr.price).toString),
      });
      console.log("You bought the item!");
    } catch (err) {
      console.log(err);
    }
  };

  const cancelTrade = async (tradeId) => {
    try {
      await contract.cancelTrade(tradeId);
      console.log("You canceled the trade!");
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <div className="walletContainer">
      <h5>MARKET</h5>
      <button className="btn btn-dark" onClick={() => getActiveTrades()}>
        Show
      </button>
      <button className="btn btn-dark" onClick={() => openTrade(2, 1)}>
        SELL
      </button>
      <button className="btn btn-dark" onClick={() => executeTrade(0)}>
        BUY
      </button>
      <button className="btn btn-dark" onClick={() => cancelTrade(0)}>
        CANCEL
      </button>
    </div>
  );
}

export default Market;
