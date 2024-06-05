/*
Copyright © 2024 Steve McGhee <smcghee@google.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"fmt"
	"os/exec"

	"github.com/spf13/cobra"
)

// onboardAppCmd represents the onboardApp command
var onboardAppCmd = &cobra.Command{
	Use:   "onboardApp",
	Short: "Onboarding an app from another repo.",
	Long: `Use this to onboard an app, eg an example github repo, or a team's existing
app or set of services.
This will make a new repo in your GitHub Org, as well as corresponding hooks to ensure 
CI/CD picks up changes made to that repo.
`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("onboardApp called")
		script := "../../onboard.sh"
		// handle args in Cobra way here
		command := exec.Command(script)
		stdout, err := command.Output()

		if err != nil {
			fmt.Println(err.Error())
			return
		}
		// Print the output
		fmt.Println(string(stdout))
	},
}

func init() {
	rootCmd.AddCommand(onboardAppCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// onboardAppCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// onboardAppCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
