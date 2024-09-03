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
}
