# Deployment strategy
export DEPLOYMENT_STRATEGY=apz
# SLO
export SLO_LATENCY_THRESHOLD=0.5s   # Must be this format
export SLO_LATENCY_GOAL=0.9        # Means 90% Must have no more than one decimal place.
export SLO_AVAILABILITY_GOAL=0.999  # Means 99.9%. Must have no more than one decimal place.
# Alerts
export ALERT_LATENCY_LOOKBACK_DURATION=3600s
export ALERT_LATENCY_THRESHOLD=10
export ALERT_AVAILABILITY_LOOKBACK_DURATION=300s
export ALERT_AVAILABILITY_THRESHOLD=1