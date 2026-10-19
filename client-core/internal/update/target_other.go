//go:build !darwin && !windows && !linux

package update

func detectTarget(string) Target { return Target{Blocker: BlockerUnsupported} }
