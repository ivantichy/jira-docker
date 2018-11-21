# News
Just moved to JIRA 7.12.3!

# JIRA in Docker container

Welcome to JIRA Docker image. What is this? This is simply something that have been missing over the whole Internet. Some fully automated one click JIRA installation. I tried to use Puppet, but official JIRA Puppet Forge stuff was obsolete.

There are two ways you can use this image:

* Scenario A - simple installation, no data import, trial or purchased license of JIRA
* Scenario B - advanced,  migration from previous installation (older version), more setup, backup

# Scenario A - Simple installation

**You can get clean JIRA installation this way:**

`docker run -d --name jira -p 8080:8080 -p 5432:5432  mental667/jira:7.12.3`

**The result is running JIRA listening on port 8080.**

As a part of the installation there is PostgreSQL database. First time you run JIRA go to `http://yourmachine:8080` and set up JIRA. 

To stop it run `docker stop jira`. To run it again use `docker start jira`. To clean all your settings (to uninstall JIRA) run `docker rm jira`. Then to run a new container use "run" command above e.g. `docker run -d --name jira -p 8080:8080  mental667/jira:7.12.3`.

Enjoy!

JIRA is set to use user jiradb and password jiradb for database connections. As PostgreSQL database is not listening to communication coming from outside of the container it is not such a big issue. You can change jiradb user password in PostgreSQL and then change dbconfig.xml in JIRA application directory to reflect this change. To get into the container to change this run `docker exec -it jira bash` and you will get bash inside the running container. Location of JIRA application directory is `/var/atlassian/jira-app` and user running database is postgres. 

# Scenario B - advanced installation, migration, backup

## Volumes, data storage, data backup and restore, migration of JIRA instances

When you run container using command like mentioned above (Scenario A) `docker run -d --name jira -p 8080:8080  mental667/jira:7.12.3` your database data, JIRA home directory containing attachments, backups etc and JIRA application directory are stored using volumes on host machine (not inside the container). You can find information about physical location using `docker inspect jira`. To find volumes location look for "mount" section in the printed output.

## To use your own path for app data

I personally start the container using this command: `docker run --cidfile ~/jiracid --rm -p 8080:8080 -v /var/docker-data/postgres:/var/lib/postgresql/9.6/main -v /var/docker-data/jira-app:/var/atlassian/jira-app -v /var/docker-data/jira-home:/var/atlassian/jira-home mental667/jira:7.12.3 "$@" &`. This causes (`-v` paramater) that Docker daemon uses paths I selected (`/var/docker-data/`). I usually backup these folders and I use them to migrate JIRA from one location to another. These folders survive container deletion which is important.

## How to set it up

1. On the Docker host machine create these folders:
 * `mkdir -p /var/docker-data/postgres`
 * `mkdir -p /var/docker-data/jira-app`
 * `mkdir -p /var/docker-data/jira-home`

2. Download start script executing: `wget https://raw.githubusercontent.com/mentalm/jira-docker/7.12.3/runjira.sh -O ~/runjira.sh && chmod +x ~/runjira.sh`

3. Install JIRA (will not start JIRA)  executing `~/runjira.sh install`. Installation is running in background. Please check state using `docker ps` to see when it is finished (container exits). It takes something like a minute or so.

4. Migrate your attachmens and settings if you have some (old JIRA) - see description bellow. Do nothing when you do not need to migrate anything e.g. when you are creating first JIRA installation.

5. Run JIRA using this command: `~/runjira.sh`. Container will set owner on folders from step 1 (postgres 1100:1100, jira-home and jira-app 1200:1200) so count with that. This is needed because JIRA and database is not running as root. You can stop container anytime using `~/stopjira.sh` command. This will gracefully stop JIRA and PostgreSQL service inside the container, container will stop, exit and delete itself (not data) after that.

6. Set up running JIRA via browser, you can use trial license to start working with JIRA. Here you can import old database you saved in Step 4 (if you are migrating from previous JIRA installation). Use native JIRA import in JIRA administration - https://confluence.atlassian.com/jira062/migrating-jira-to-another-server-588581560.html#MigratingJIRAtoAnotherServer-3.6ImportyouroldJIRAdataintoyournewJIRA). 

7. Set backup

When you backup this on Docker host machine:

* `/var/docker-data/postgres`
* `/var/docker-data/jira-app`
* `/var/docker-data/jira-home`
 
Then you are safe. You should set up database backups inside JIRA application. Your backups will be automatically saved into your JIRA home directory as zip files and you can use them to restore JIRA database later (https://confluence.atlassian.com/jira/backing-up-data-185729581.html).

## Clean settings

Anytime you can run `~/runjira.sh purge`. This will permanently erase all your data. You can use it to start from scratch (clean JIRA installation and clean database).

## Data migration from old JIRA instance to a new one (from Step 4)

1. In old running JIRA instance perform a database backup, follow steps in JIRA Administration / System / System backup. JIRA typically stores database backups in JIRA home directory under export directory. For further import, copy your export file (zip) into /import directory located in JIRA home directory. You can check your folder settings in JIRA Administration / System / System info / File paths.

2. Stop old JIRA instance. Back up your JIRA home and JIRA application directory. Copy JIRA home directory to /var/docker-data/jira-home on your docker host machine.

3. Check dbconfig.xml file in JIRA home directory to use right database username and password (we used jiradb/jiradb).

4. Perform your extra settings in JIRA app directory (like editing server.xml) in `/var/docker/`-

## Notes
* Inside the container JAVA is running with -Djava.net.preferIPv4Stack=true directive to force Tomcat to listen on IPv4 (without that Tomcat is listening on IPv6 only).
* I removed HTTPS support from JIRA container as this should be managed by separate container doing proxy/load balancing.

## License
Copyright (c) 2018, Ivan Tichý. All rights reserved.

You may not use the identified files except in compliance with the GNU General Public License v3.0 (the "License.")

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>. Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
