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
	"os"
	"os/exec" // do better

	"github.com/spf13/cobra"
)

// rolloutCmd represents the rollout command
var rolloutCmd = &cobra.Command{
	Use:   "rollout",
	Short: "A quick way to rollout an application",
	Long:  `more words go here.`,
	Run: func(cmd *cobra.Command, args []string) {

		// from deploy.sh:
		// [[ ${APPLICATION} == "whereami" ]] && echo -e "\e[95mStarting to deploy application ${APPLICATION}...\e[0m" && gcloud builds submit --config=examples/whereami/ci.yaml --substitutions=_PROJECT_ID=${PROJECT_ID},_SHORT_SHA=${SHORT_SHA}  --async

		// should probably do it with cloud build API:
		// https://pkg.go.dev/cloud.google.com/go/cloudbuild@v1.15.1/apiv2#pkg-overview
		// ctx := context.Background()
		// cloudbuildService, err := cloudbuild.NewService(ctx)

		gcloudService := "builds"
		gcloudMethod := "submit"

		appStr := cmd.Flag("app").Value.String()
		configArg := "config=examples/" + appStr + "/ci.yaml"
		substitutionsArg := ""
		// substitutionsArg = "PROJECT_ID=" =examples/" + app + "/ci.yaml"
		asyncArg := "async"

		gcmd := exec.Command("gcloud", gcloudService, gcloudMethod, configArg, substitutionsArg, asyncArg)
		gcmd.Env = append(os.Environ(),
			"PROJECT_ID=duplicate_value", // ignored
			"SHORT_SHA=actual_value",
		)

		fmt.Println(gcmd.String())

		err := gcmd.Run()
		if err != nil {
			fmt.Println(err)
		}

		fmt.Println("rollout called")
	},
}

func init() {
	rootCmd.AddCommand(rolloutCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// rolloutCmd.PersistentFlags().String("foo", "", "A help for foo")
	rolloutCmd.PersistentFlags().String("app", "", "Name of app to rollout")
	rolloutCmd.PersistentFlags().String("strategy", "", "Type of rollout strategy")

	rolloutCmd.MarkFlagRequired("app") // not working yet

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// rolloutCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
