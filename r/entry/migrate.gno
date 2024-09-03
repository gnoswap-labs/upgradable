package entry

import (
	"std"

	state "gno.land/r/demo/state"
	token "gno.land/r/demo/token"
)

const adminAddressPath = "gno.land/r/demo/admin" 

var currentLogicRealmPath = "gno.land/r/demo/logic/v1"

func assertAdminAddress() {
	if std.PrevRealm().PkgPath() != adminAddressPath {
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

func assertMigrationState(expected MigrationState) {
	if migrationState != expected {
		panic("Migration state mismatch")
	}
}

func ReplaceLogicRealm(newLogicRealm string) {
	assertAdminAddress()
	assertMigrationState(MigrationStateStable)
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
