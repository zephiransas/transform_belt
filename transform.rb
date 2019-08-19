require 'json'
require 'aws-sdk-ecs'

def execute(event:, context:)
  event['Records'].each do |record|
    key = parse_record(record)
    run_task(key)
  end

  { statusCode: 200, body: JSON.generate('Go Serverless v1.0! Your function executed successfully!') }
end

def parse_record(record)
  bucket_name = record['s3']['bucket']['name']
  key = record['s3']['object']['key']
  "#{bucket_name}/#{key}"
end

def run_task(key)
  client = Aws::ECS::Client.new

  client.run_task(
    cluster: 'transform-cluster',
    task_definition: 'transform',
    launch_type: 'FARGATE',
    count: 1,
    overrides: {
      container_overrides: [
        {
          name: 'app',
          command: ['echo', "#{key}"]
        }
      ]
    },
    network_configuration: {
      awsvpc_configuration: {
        subnets: [ ENV['SUBNET_ID'] ],
        security_groups: [ ENV['SECURITY_GROUP'] ],
        assign_public_ip: "ENABLED"
      },
    }
  )
end