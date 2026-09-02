# DASH Search Local Docker Installation

### Prerequisites  
* A Github Token for reading NCAR private repositories
* A local Docker Installation

### Local Deployment Steps
1. Create a local clone of this repo.
2. Copy the file .env.example to .env
3. Place your Github token value in the file `.github_token` in the repo top-level directory.  It will be ignored by git.
4. Run this command:  `docker compose -f docker-compose.yml build`
5. Then run: `docker compose -f docker-compose.yml up`
6. The nginx service will come up last, at which point you can browse to [https://localhost:8443](https://localhost:8443).
7. Use the command `docker compose down -v` to remove pre-existing data from volumes and start from scratch.

### Debugging CKAN

1.  Note that when a remote debug connection is active, other CKAN commands, like to harvest records, will block. 
    So it's best to run the harvesting commands before making the connection active. 
2.  To connect a remote debugger, type CMD-D to start the debugger and find what lines must be
    inserted somewhere, preferably in helpers.py.  They will look something like this:
```
    import pydevd_pycharm
    pydevd_pycharm.settrace('10.0.0.159', port=6666, stdout_to_server=True, stderr_to_server=True, suspend=False)
    import sys; print('Python %s on %s' % (sys.version, sys.platform))
```
3. To reload CKAN, install ps, do ps aux, and find the lowest-numbered UWSGI process.
```
    docker compose exec --user root ckan sh -c 'apt-get update && apt-get install -y procps'
    docker compose exec ckan ps aux
    docker compose exec ckan kill -HUP <process_id>
```
4. To login to the container, type `bin/shell`.

### Harvesting Test Records

To fully test out the DASH Search interface, it helps to harvest a small number of records from a test WAF.  At this time, harvesting is done manually after deployment with these steps:
1. Login to the ckan container:  `docker exec -it ckan-docker-ckan-1 /bin/bash`
2. Check that the harvester source was set up correctly by running: `ckan harvester sources`.  You should see one active harvest source.
3. Begin harvesting a small number of records with: `ckan harvester run-test mini-waf`.  

You should then see the harvester log output begin. Refreshing the CKAN Resources page during harvesting should show the already harvested records.

