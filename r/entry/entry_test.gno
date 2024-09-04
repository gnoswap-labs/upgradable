package entry

import (
	"testing"

	"gno.land/r/demo/state"
	v2 "gno.land/r/demo/logic/v2"
)

const (
	v1Path = "gno.land/r/demo/logic/v1"
	v2Path = "gno.land/r/demo/logic/v2"
)

func TestContractUpgrade(t *testing.T) {
	SetTestMode(true)
	defer SetTestMode(false)

	t.Run("initial state", func(t *testing.T) {
		if GetCurrentLogicRealm() != v1Path {
			t.Errorf("expected version to be v1, got %s", GetCurrentLogicRealm())
		}
	})

	t.Run("version check", func(t *testing.T) {
		currentVersion := state.GetCurrentLogicRealm()
		if currentVersion != v1Path {
			t.Errorf("expected version to be v1, got %s", currentVersion)
		}

		ReplaceLogicRealm(v2Path)
		newVersion := state.GetCurrentLogicVersion()
		if currentVersion == newVersion {
			t.Errorf("expected version to change, got %s", newVersion)
		}
	})

	t.Run("roll back", func(t *testing.T) {
		initialVersion := state.GetCurrentLogicVersion()

		ReplaceLogicRealm(v2Path)
		if state.GetCurrentLogicVersion() != "v2" {
			t.Errorf("expected version to change, got %s", state.GetCurrentLogicVersion())
		}

		RollbackMigration()

		finalVersion := state.GetCurrentLogicVersion()

		if initialVersion != finalVersion {
			t.Errorf("expected version to roll back, got %s", finalVersion)
		}
	})

	t.Run("upgrade to v2", func(t *testing.T) {
		ReplaceLogicRealm(v2Path)

		// if GetCurrentLogicRealm() != v2Path {
		// 	t.Errorf("expected version to be v2, got %s", GetCurrentLogicRealm())
		// }
	})
}
