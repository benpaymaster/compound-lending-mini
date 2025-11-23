import React, { useState } from "react";
import { useLendingVault } from "../../frontend-next/components/useLendingVault";

type BalanceCardProps = {
  assetAddress: string;
  assetSymbol: string;
};

const BalanceCard: React.FC<BalanceCardProps> = ({ assetAddress, assetSymbol }) => {
  const [withdrawAmount, setWithdrawAmount] = useState("");
  const { balance, withdraw, loading, error, fetchBalance } = useLendingVault(assetAddress);

  const handleWithdraw = async (e: React.FormEvent) => {
    e.preventDefault();
    if (withdrawAmount) {
      await withdraw(withdrawAmount);
      setWithdrawAmount("");
      await fetchBalance();
    }
  };

  return (
    <div style={{ border: "1px solid #eee", borderRadius: 8, padding: 16, marginBottom: 16 }}>
      <h3>Your Balance</h3>
      <p>
        {balance} {assetSymbol}
      </p>
      <form onSubmit={handleWithdraw} style={{ marginTop: 12 }}>
        <label>
          Withdraw Amount ({assetSymbol}):
          <input
            type="number"
            value={withdrawAmount}
            onChange={e => setWithdrawAmount(e.target.value)}
            min="0"
            step="any"
            style={{ marginLeft: 8 }}
          />
        </label>
        <button type="submit" style={{ marginLeft: 12 }} disabled={loading}>
          {loading ? "Withdrawing..." : "Withdraw"}
        </button>
      </form>
      {error && <div style={{ color: "red" }}>{error}</div>}
    </div>
  );
};

export default BalanceCard;
