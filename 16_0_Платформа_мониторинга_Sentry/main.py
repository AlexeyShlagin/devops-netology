import sentry_sdk

sentry_sdk.init(
    dsn = "https://d9108941a4664ed686b22dd05cb81aa3@o4506502465912832.ingest.sentry.io/4506502472466433"
)

if __name__ == "__main__":
    division = 1 / 0