package pinyin

import "testing"

func TestIndex(t *testing.T) {
	cases := []struct {
		s, q string
		want int
	}{
		{"会议链接：https://meeting.example.com", "huiyi", 0},
		{"会议链接", "hy", 0},
		{"会议链接", "huiy", 0},
		{"会议链接", "hyi", 0},
		{"会议链接", "hyl", 0},
		{"会议链接", "lianjie", 2},
		{"会议链接", "lj", 2},
		{"周会改到周四下午 3 点", "zhouhui", 0},
		{"周会改到周四下午 3 点", "zhh", 0},
		{"周会改到周四下午 3 点", "zh", 0},
		{"明天的周报", "zhoubao", 3},
		{"明天的周报", "zb", 3},
		// 打到一半：最后一段只是读音的开头
		{"快递单号", "kuaidid", 0},
		{"快递单号", "kuaidi", 0},
		// 多音字：「长」zhang / chang，「行」xing / hang
		{"银行卡号", "yinhang", 0},
		{"长期有效", "changqi", 0},
		{"组长", "zuzhang", 0},
		// ü 写作 v 或 u
		{"绿色", "lvse", 0},
		{"绿色", "luse", 0},
		// 中英混排：英文按原样
		{"发pdf给我", "fapdf", 0},
		{"发 PDF 给我", "fapdfgw", 0}, // 拼音里不打空格
		{"周会改到周四下午 3 点", "xiawu3dian", 6},
		// 没有汉字的文本不在这里匹配
		{"meeting link", "ml", -1},
		// 声母之外的单个字母不能代表一个字的中间
		{"会议", "ui", -1},
		{"会议", "huiyix", -1},
	}
	for _, c := range cases {
		if got := Index(c.s, c.q); got != c.want {
			t.Errorf("Index(%q, %q) = %d，应为 %d", c.s, c.q, got, c.want)
		}
	}
}

func TestQuery(t *testing.T) {
	cases := map[string]string{
		"huiyi":    "huiyi",
		"Hui Yi":   "huiyi",
		"hui'yi":   "huiyi",
		"h":        "",
		"会议":       "",
		"docker 1": "",
		"":         "",
	}
	for in, want := range cases {
		if got := Query(in); got != want {
			t.Errorf("Query(%q) = %q，应为 %q", in, got, want)
		}
	}
}

func BenchmarkIndexLongText(b *testing.B) {
	long := ""
	for len([]rune(long)) < 4000 {
		long += "这是一段很长的会议纪要，用来测试拼音搜索在长文本上的速度。"
	}
	for i := 0; i < b.N; i++ {
		Index(long, "kuaididanhao")
	}
}
