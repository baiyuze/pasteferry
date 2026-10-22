//go:build !darwin && !linux && !windows

package power

import "errors"

func inhibit(string) (func(), error) { return nil, errors.New("unsupported") }
