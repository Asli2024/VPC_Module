package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// Path to the Terraform code that will be tested
		TerraformDir: "../example/basic/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			// Add any necessary variables here
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of the VPC ID
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	// Verify the VPC ID is not empty
	assert.NotEmpty(t, vpcID)

	// Clean up the state file after the test
	stateFilePath := filepath.Join(terraformOptions.TerraformDir, "terraform.tfstate")
	err := os.Remove(stateFilePath)
	if err != nil {
		t.Fatalf("Failed to delete state file: %v", err)
	}
}
