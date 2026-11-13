package p2p

import "testing"

func TestIndependentBudgetSharedAcrossTransfers(t *testing.T) {
	m := NewManager(ManagerOptions{SelfID: "test", DisableEgressProbe: true})
	defer m.Close()
	var releases []func()
	for range 3 {
		release, err := m.reserveBulk("peer")
		if err != nil {
			t.Fatal(err)
		}
		releases = append(releases, release)
		defer release()
	}
	if release, err := m.reserveBulk("peer"); err == nil {
		release()
		t.Fatal("fourth extra connection exceeded per-device budget")
	}
	other, err := m.reserveBulk("other")
	if err != nil {
		t.Fatal(err)
	}
	other()
	releases[0]()
	releases[0]() // Closing twice must not release another slot.
	replacement, err := m.reserveBulk("peer")
	if err != nil {
		t.Fatal(err)
	}
	defer replacement()
	if release, err := m.reserveBulk("peer"); err == nil {
		release()
		t.Fatal("double close corrupted the budget")
	}
}
