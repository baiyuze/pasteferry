package lang

import "testing"

func TestMatch(t *testing.T) {
	cases := map[string]string{
		"":            "",
		"zh":          "zh-Hans",
		"zh-Hans":     "zh-Hans",
		"zh-Hans-HK":  "zh-Hans",
		"zh-CN":       "zh-Hans",
		"zh_CN.UTF-8": "zh-Hans",
		"zh-Hant":     "zh-Hant-TW",
		"zh-Hant-TW":  "zh-Hant-TW",
		"zh-TW":       "zh-Hant-TW",
		"zh_TW.UTF-8": "zh-Hant-TW",
		"zh-Hant-HK":  "zh-Hant-HK",
		"zh-HK":       "zh-Hant-HK",
		"zh-MO":       "zh-Hant-HK",
		"en":          "en",
		"en-GB":       "en",
		"en_US.UTF-8": "en",
		"ja-JP":       "ja",
		"ar":          "ar",
		"ar-EG":       "ar",
		"ar_SA.UTF-8": "ar",
		"pt-BR":       "pt-BR",
		"pt-PT":       "pt-BR",
		"pt_PT@euro":  "pt-BR",
		"de-DE":       "de",
		"ko-KR":       "ko",
		"uk-UA":       "uk",
		"vi_VN":       "vi",
		"id-ID":       "id",
		"nl-NL":       "",
		"C":           "",
		"sr-Latn-RS":  "",
	}
	for in, want := range cases {
		if got := Match(in); got != want {
			t.Errorf("Match(%q) = %q，应为 %q", in, got, want)
		}
	}
}

func TestValid(t *testing.T) {
	for _, s := range Supported {
		if !Valid(s) {
			t.Errorf("Valid(%q) = false", s)
		}
		if Match(s) != s {
			t.Errorf("Match(%q) = %q，设置里的写法应原样对上", s, Match(s))
		}
	}
	for _, s := range []string{"", "pt", "zh", "fr-FR", "xx"} {
		if Valid(s) {
			t.Errorf("Valid(%q) = true", s)
		}
	}
}
