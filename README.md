# README

## Installation

### Prerequisites
- Ruby 3.4.0 or higher
- Rails 8.0
- PostgreSQL
- Bun

### Steps

1. Clone the repository
   ```bash
   git clone https://github.com/Oldharlem/high_volume_chat.git
   cd high_volume_chat
   ```


2. Install dependencies:
   ```bash
   bundle install
   bun install
   ```

3. Setup database:
   ```bash
   # Create and setup the database
   rails db:setup
   ```

4. Start the server:
   ```bash
   bin/dev
   ```

5. Visit http://localhost:3000 in your browser



# High-Volume Group Messaging App

## Scaling Considerations

### Current Optimizations
- Message pagination with infinite scroll
- Proper database indexing for frequent queries
- N+1 query prevention with includes
- Real-time updates via ActionCable
- Caching of group memberships
- Counter cache for message counts to avoid expensive COUNT queries

### Future Scaling Solutions

1. Database Scaling:
   - Partition messages by date or group_id
   - Consider moving older messages to cold storage
   - Implement read replicas for message queries

2. Caching Layer:
   - Add Redis for caching and pub/sub
   - Cache frequently accessed messages
   - Cache group membership lists

3. Background Processing:
   - Move message broadcasting to Sidekiq
   - Add message search indexing with Elasticsearch
   - Handle notifications asynchronously

4. Application Scaling:
   - Add load balancing
   - Scale ActionCable servers separately
   - Consider breaking into microservices

5. Monitoring and Analytics:
   - Add NewRelic/Scout for performance monitoring
   - Track message metrics with StatsD/Datadog
   - Set up error tracking with Sentry
   
# high_volume_chat
