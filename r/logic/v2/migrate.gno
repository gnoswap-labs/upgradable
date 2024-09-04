package v2

import (
	"std"

	entry "gno.land/r/demo/entry"
)

func Migrate() {
	entry.MigrateLogicRealm(
		Swap,
		AddLiquidity,
		RemoveLiquidity,
	)
}
