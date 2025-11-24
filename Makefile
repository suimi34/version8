database:
	docker compose up -d db

bundle:
	docker compose run --rm --no-deps web bundle

migrate:
	docker compose run --rm --no-deps web bundle exec rails db:migrate

web:
	docker compose up --no-deps web

brakeman:
	docker compose run --rm --no-deps web brakeman -A

rubocop:
	docker compose run --rm --no-deps web bundle exec rubocop

rubocop_fix:
	docker compose run --rm --no-deps web bundle exec rubocop --autocorrect

test_web:
	docker compose -f docker-compose.test.yml up --no-deps -d test_web

test_brakeman:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web brakeman -A

test_rubocop:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rubocop

test_precompile:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rails tailwindcss:build
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rails assets:precompile

test_bundle:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle

test_db:
	docker compose -f docker-compose.test.yml up -d test_db

test_migrate:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web rails db:create
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web rails db:migrate

rspec:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web rspec spec/

rspec_down:
	docker compose -f docker-compose.test.yml down -v

# Cloud Build経由でデプロイ
deploy:
	@echo "🚀 Deploying via Cloud Build..."
	@bash -c 'set -a && source .env.production && set +a && \
		gcloud builds submit --config cloudbuild.yaml \
		  --project "$$GCP_PROJECT_ID" \
			--substitutions _RAILS_MASTER_KEY="$$RAILS_MASTER_KEY",_DB_HOST="$$DB_HOST",_DB_NAME="$$DB_NAME",_DB_USER="$$DB_USER",_DB_PASS="$$DB_PASS",_DB_CABLE_NAME="$$DB_CABLE_NAME" \
			--no-source'
	@echo "✅ Deployment completed!"
