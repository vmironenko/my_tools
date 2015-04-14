#!/bin/bash
ZZZ="10.1.63.240:2181,10.1.63.241:2181,10.1.63.242:2181,10.1.63.243:2181,10.1.63.244:2181,10.1.63.245:2181,10.1.63.246:2181,10.1.63.247:2181"
PPP="/opt/kafka/current/bin/"
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic counters --partitions 8 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-ad-responses --partitions 6 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-noad-responses --partitions 6 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-blacklisted-responses --partitions 6 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-enrichment --partitions 6 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-enrichment-blacklisted --partitions 6 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-clicks --partitions 6 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-impressions --partitions 6 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
${PPP}kafka-topics.sh --zookeeper $ZZZ --create --topic ads-opt-out --partitions 2 --replication-factor 2 --config retention.ms=604800000 --config cleanup.policy=delete
