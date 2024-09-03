package entry

import (
	"testing"

	"gno.land/r/demo/state"
)

func TestContractUpgrade(t *testing.T) {
	SetTestMode(true)
	defer SetTestMode(false)

	t.Run("version check", func(t *testing.T) {
		initialVersion := state.GetCurrentLogicVersion()
		ReplaceLogicRealm("gno.land/r/demo/logic/v2")

		newVersion := state.GetCurrentLogicVersion()

		if initialVersion == newVersion {
			t.Errorf("expected version to change, got %s", newVersion)
		}
	})

	t.Run("roll back", func(t *testing.T) {
		initialVersion := state.GetCurrentLogicVersion()

		ReplaceLogicRealm("gno.land/r/demo/logic/v2")
		if state.GetCurrentLogicVersion() != "v2" {
			t.Errorf("expected version to change, got %s", state.GetCurrentLogicVersion())
		}

		RollbackMigration()

		finalVersion := state.GetCurrentLogicVersion()

		if initialVersion != finalVersion {
			t.Errorf("expected version to roll back, got %s", finalVersion)
		}
	})

	t.Run("swap functionality", func(t *testing.T) {
		// AddLiquidity(1000, 1000)

		// initReserve0, initReserve1 := logic_v2.GetReserves()

		// amountOut := Swap("foo", 100)

		// if amountOut == 0 {
		// 	t.Errorf("swap failed, expected non-zero amount")
		// }

		// newReserve0, newReserve1 := logic_v2.GetReserves()
		// if newReserve0 <= initialReserve0 || newReserve1 >= initialReserve1 {
		// 	t.Errorf("Reserves not updated correctly after swap")
		// }
	})
}
