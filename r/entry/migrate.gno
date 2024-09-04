package entry

import (
	"std"

	state "gno.land/r/demo/state"
	token "gno.land/r/demo/token"
)

const adminAddressPath = "gno.land/r/demo/admin" 

var (
	currentLogicRealmPath = "gno.land/r/demo/logic/v1"
	isTestMode = false
)

func SetTestMode(enabled bool) {
	isTestMode = enabled
}

func assertAdminAddress() {
	if std.PrevRealm().PkgPath() != adminAddressPath && !isTestMode {
		panic("Admin address mismatch")
	}
}

func assertLogicRealm() {
	if std.PrevRealm().PkgPath() != currentLogicRealmPath {
		panic("Logic realm mismatch")
	}
}

type MigrationState byte

const (
	MigrationStateStable = iota
	MigrationStateReplaced
)

var migrationState MigrationState = MigrationStateStable
var previousLogicRealmPath string

func assertMigrationState(expected MigrationState) {
	if migrationState != expected && !isTestMode {
		panic("Migration state mismatch")
	}
}

func ReplaceLogicRealm(newLogicRealm string) {
	assertAdminAddress()
	assertMigrationState(MigrationStateStable)

	previousLogicRealmPath = currentLogicRealmPath
	currentLogicRealmPath = newLogicRealm
	state.MigrateLogicRealm(newLogicRealm)
	token.MigrateLogicRealm(newLogicRealm)
	migrationState = MigrationStateReplaced
}

func MigrateLogicRealm(
	_swap func(prev string, tokenIn string, amountIn uint64) (amountOut uint64),
	_addLiquidity func(prev string, amount0 uint64, amount1 uint64) (shareAmount uint64),
	_removeLiquidity func(prev string, shareAmount uint64) (amount0 uint64, amount1 uint64),
) {
	assertLogicRealm()
	assertMigrationState(MigrationStateReplaced)
	swap = _swap
	addLiquidity = _addLiquidity
	removeLiquidity = _removeLiquidity
	migrationState = MigrationStateStable
}

func ConfirmMigration() {
	assertAdminAddress()
	assertMigrationState(MigrationStateReplaced)

	migrationState = MigrationStateStable
	previousLogicRealmPath = ""
}

func RollbackMigration() {
	assertAdminAddress()
	assertMigrationState(MigrationStateReplaced)

	currentLogicRealmPath = previousLogicRealmPath
	previousLogicRealmPath = ""

	migrationState = MigrationStateStable
}

func GetCurrentLogicRealm() string {
	return currentLogicRealmPath
}
