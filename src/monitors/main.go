package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os/exec"
	"os/user"
	"regexp"
	"strings"

	"gopkg.in/yaml.v2"
)

type profile struct {
	Monitors []struct {
		Monitor    string
		Workspaces []struct {
			Name string
		}
	}
}

type profiles map[string]profile
type monitors map[string]struct{}

var profilePath string
var profileName string
var isListProfiles bool
var isListMonitors bool

func init() {
	usr, err := user.Current()
	if err != nil {
		panic(err)
	}

	path := fmt.Sprintf("%s/.config/i3/profiles.yml", usr.HomeDir)
	flag.StringVar(&profilePath, "c", path, "-c config path")
	flag.StringVar(&profileName, "p", "", "-p profile name")
	flag.BoolVar(&isListProfiles, "l", false, "list profiles")
	flag.BoolVar(&isListMonitors, "m", false, "list monitors")
}

func main() {
	flag.Parse()

	prof, err := loadProfiles(profilePath)
	if err != nil {
		panic(err)
	}

	if isListProfiles {
		listProfiles(prof)
		return
	}

	monitors, err := listMonitors()
	if err != nil {
		panic(err)
	}
	if isListMonitors {
		for m, _ := range monitors {
			fmt.Println(m)
		}
		return
	}

	if profileName != "" {
		fmt.Println("configure monitors")
		p, ok := prof[profileName]
		if !ok {
			fmt.Printf("Profile '%s' not found\n", profileName)
			return
		}
		if err = changeWorkspace(p, monitors); err != nil {
			panic(err)
		}
	}
}

func listProfiles(p profiles) {
	for name, _ := range p {
		fmt.Println(name)
	}
}

func loadProfiles(path string) (profiles, error) {
	file, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}

	var prof profiles
	err = yaml.Unmarshal(file, &prof)
	if err != nil {
		return nil, err
	}
	return prof, nil
}

func listMonitors() (monitors, error) {
	ret := make(monitors)
	out, err := exec.Command("xrandr", "--listmonitors").Output()
	if err != nil {
		return ret, err
	}

	re := regexp.MustCompile(`[A-Z0-1-]{2,}\n`)
	for _, monitor := range re.FindAllString(string(out), -1) {
		name := strings.Replace(monitor, "\n", "", 1)
		ret[name] = struct{}{}
	}
	return ret, nil
}

func changeWorkspace(p profile, m monitors) error {
	//move := "MOVE WORKSPACE %s OUTPUT %s"
	primary := ""
	for monitor, _ := range m {
		primary = monitor
		break
	}

	fmt.Printf("primary: %s\n", primary)
	fmt.Println(m)

	for _, m1 := range p.Monitors {
		c := m1.Monitor
		fmt.Println(c)
		if monitor, ok := m[c]; !ok {
			fmt.Println(monitor)
		}
	}
	return nil
}
