locals {
  common_tags = {
    managed-by = "terraform"
  }

  workloads = {
    dev01 = { env = "dev01" }
    dev02 = { env = "dev02" }
  }

  teams = {
    teamA = { team = "Team A" }
    teamB = { team = "Team B" }
  }

  inherited_tags = toset(["team", "env"])
}
