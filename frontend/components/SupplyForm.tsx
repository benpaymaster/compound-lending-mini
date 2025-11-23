
import React, { useState } from "react";
import { useLendingVault } from "../../frontend-next/components/useLendingVault";

type SupplyFormProps = {
  assetAddress: string;
  assetSymbol: string;
};

const SupplyForm: React.FC<SupplyFormProps> = ({ assetAddress, assetSymbol }) => {
  const [amount, setAmount] = useState("");
  const { supply, loading, error } = useLendingVault(assetAddress);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (amount) {
      await supply(amount);
      setAmount("");
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ marginBottom: 16 }}>
      <label>
        Supply Amount ({assetSymbol}):
        <input
          type="number"
          value={amount}
          onChange={e => setAmount(e.target.value)}
          min="0"
          step="any"
          style={{ marginLeft: 8 }}
        />
      </label>
      <button type="submit" style={{ marginLeft: 12 }} disabled={loading}>
        {loading ? "Supplying..." : "Supply"}
      </button>
      {error && <div style={{ color: "red" }}>{error}</div>}
    </form>
  );
};

export default SupplyForm;
