#include <curl/curl.h>
#include <stdio.h>

int main()
{
    CURL *curl = curl_easy_init();
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1);
    curl_easy_setopt(curl, CURLOPT_URL, "http://whatismyip.akamai.com");
    curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_SOCKS5);
    curl_easy_setopt(curl, CURLOPT_PROXY, "<ip>");
    curl_easy_setopt(curl, CURLOPT_PROXYPORT, 50001);
    curl_easy_perform(curl);
    puts("");
    curl_easy_setopt(curl, CURLOPT_PROXY, "<ip>");
    curl_easy_setopt(curl, CURLOPT_PROXYPORT, 50002);
    curl_easy_perform(curl);
    puts("");
}
