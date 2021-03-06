package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

// cliS3CmdMv is the Cobra CLI call
func cliS3CmdMv() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "mv CLUSTER BUCKET1/OBJECT1 BUCKET2/OBJECT2",
		Short: "Move object",
		Args:  cobra.ExactArgs(3),
		Run:   S3CmdMv,
		DisableFlagsInUseLine: true,
	}

	return cmd
}

// S3CmdMv wraps s3cmd command in the container
func S3CmdMv(cmd *cobra.Command, args []string) {
	containerName := containerNamePrefix + args[0]

	notExistCheck(containerName)
	notRunningCheck(containerName)
	command := []string{"s3cmd", "mv", "s3://" + args[1], "s3://" + args[2]}
	output := strings.TrimSuffix(string(execContainer(containerName, command)), "\n") + " on cluster " + containerName
	fmt.Println(output)
}
