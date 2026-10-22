package sync

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/baiyuze/pasteferry/client-core/internal/store"
)

// 收藏可以起别名：列表显示它、按它（含拼音）能搜到；取消收藏后不显示也搜不到，撤销后回来。
func TestFavoriteAlias(t *testing.T) {
	env := newFavoriteEngine(t)
	ctx := context.Background()
	src := putText(t, env.e, "src", "pnpm install --frozen-lockfile", time.Now().Add(-time.Hour))
	fav, err := env.e.SetFavorite(ctx, src.ID, true)
	if err != nil {
		t.Fatal(err)
	}

	if _, err := env.e.SetAlias(src.ID, "复制记录"); err == nil {
		t.Error("复制记录不该能起别名")
	}
	got, err := env.e.SetAlias(fav.ID, "  装依赖\n 命令 ")
	if err != nil {
		t.Fatal(err)
	}
	if got.Alias != "装依赖 命令" {
		t.Errorf("别名 = %q，应压掉换行与首尾空白", got.Alias)
	}
	if p := recordProto(got); p.GetAlias() != "装依赖 命令" {
		t.Errorf("ClipRecord 的别名 = %q", p.GetAlias())
	}

	favorites := store.Filter{Favorites: true}
	for _, q := range []string{"依赖", "zyl", "zhuangyilai"} {
		found, err := env.e.SearchHistory(q, 50, favorites)
		if err != nil {
			t.Fatal(err)
		}
		if len(found) != 1 || found[0].ID != fav.ID {
			t.Errorf("按别名搜 %q 得到 %v", q, found)
		}
	}

	long := strings.Repeat("长", maxAlias+20)
	if got, _ := env.e.SetAlias(fav.ID, long); len([]rune(got.Alias)) != maxAlias {
		t.Errorf("超长的别名应截到 %d 个字，实际 %d", maxAlias, len([]rune(got.Alias)))
	}
	if _, err := env.e.SetAlias(fav.ID, "装依赖"); err != nil {
		t.Fatal(err)
	}

	back, err := env.e.SetFavorite(ctx, fav.ID, false)
	if err != nil {
		t.Fatal(err)
	}
	if p := recordProto(back); p.GetAlias() != "" {
		t.Errorf("取消收藏后不该显示别名：%q", p.GetAlias())
	}
	if found, _ := env.e.SearchHistory("依赖", 50, store.Filter{}); len(found) != 0 {
		t.Errorf("复制记录不该按别名搜到：%v", found)
	}

	again, err := env.e.SetFavorite(ctx, back.ID, true)
	if err != nil {
		t.Fatal(err)
	}
	if again.Alias != "装依赖" {
		t.Errorf("撤销取消收藏后别名 = %q，应回来", again.Alias)
	}
	if got, _ := env.e.SetAlias(again.ID, "   "); got.Alias != "" {
		t.Errorf("清空别名后 = %q", got.Alias)
	}
}
