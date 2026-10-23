# Checkpoint compression measurement

This research-only study recompresses the exact raw tar stream from immutable batch000002 on the Mac. It does not change the exporter, arrival helper, original archive, proof objects, current batch3, or Git.

The original gzip3 archive is59,393,753bytes. The decoded tar is239,052,800bytes, SHA256d6747493f893a7651a56579e77c4a1cb8227f2d5c45f8edb8969eb794ff70863. Every tested encoding decodes to that exact identity. The original archive was hashed before and after the main benchmark and remained8cb1e274875167131b34f533b7cf1d510591cdb877cba4b09d7ee25386adc353.

| Encoding | Bytes | Compression seconds |
| --- | ---: | ---: |
| gzip3 baseline |59,393,743|2.45|
| gzip9 |54,136,378|62.15|
| XZ3 |40,619,280|12.51|
| XZ6 |35,152,160|84.11|

The ten-byte difference between original gzip3 and baseline comes from gzip header framing; their decoded tar bytes are identical. XZ3 cuts transferred bytes31.61%. At observed batch2 throughput242,977bytes/s, modeled compression plus transfer falls from246.89s to179.69s, approximately67.20s or27.2%. This uses Mac compression timings and the prior transport rate; future source-host timings and archive mixtures may differ. Arrival verification time is omitted from this simple model.

The main benchmark finished with actual exit0 after165.41s, one compression worker, final peakRSS138,149,888bytes. Darwin rejected an initial attempt to set RLIMIT_DATA before archive data access; its failure is preserved. The successful version admits queried liblzma working memory below256MiB including baseline/buffers, checks measured peakRSS below512MiB, and limits CPU600s/wall900s. It does not claim a hard OS physical-RAM limit. The later gzip3 baseline finished exit0 in3.08s. Binary benchmark outputs remain outside Git.

Transport has8 workers, averaging7.835 combined jobs active,199 jobs and244.442s total. The logs combine local reads with remote writes and cannot identify fixed-call cost separately. A600k raw/800k base64 same-channel chunk test is proposed only; no larger-chunk transfer was performed.

Recommend a separately reviewed XZ preset3 exporter/arrival version preserving all source, artifact, receipt, snapshot, chunk and dependency checks. Existing gzip flow and already frozen archives must remain available. This is infrastructure evidence, not mathematical proof acceptance.
