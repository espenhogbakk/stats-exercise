/**
 * This should ideally be put into seperate files but in the interrest of
 * keeping this easy to review and since it's only a prototype I'll keep it all
 * in one single file
 */

var reports = angular.module('reports', []);

/**
 * Directive to easily render a pie chart of referrers for a site
 */
reports.directive('referralChart', function() {
  return {
    restrict: 'E',
    scope: {
      site: '=',
    },
    link: function ($scope, element) {
      Highcharts.chart(element[0], {
        chart: {
          type: 'pie'
        },

        title: {
          text: $scope.site.url,
        },

        plotOptions: {
          pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
              enabled: false,
            }
          }
        },

        credits: {
          enabled: false,
        },

        series: [{
          name: 'Referrals',
          data: _.map($scope.site.referrers, function(referrer) {
            return {
              name: referrer.url,
              y: referrer.visits,
            }
          })
        }]
      });
    }
  };
});


/**
 * Directive to easily render a column chart
 */
reports.directive('topUrlsChart', function() {
  return {
    restrict: 'E',
    scope: {
      title: '@',
      categories: '=',
      series: '=',
    },
    link: function ($scope, element) {
      $scope.$watch('series', function(newValue, oldValue) {
        if (newValue !== oldValue) {
          Highcharts.chart(element[0], {
            chart: { type: 'column' },

            title: null,

            xAxis: {
              categories: $scope.categories,
            },

            yAxis: {
              title: {
                text: 'Visits',
              }
            },

            credits: {
              enabled: false,
            },

            series: $scope.series,
          });
        }
      });
    }
  };
});

/**
 * Controller for Top URLs
 */
reports.controller('TopUrlsController', function TopUrlsController($scope, $http) {
  $scope.dates = [];
  $scope.series = [];

  // I would usually just configure Angular to send the HTTP header
  // `Accept: application/json` instead of doing `.json`, but hey, it's
  // prototype right?
  $http.get('top_urls.json').then(function (response) {
    var data = response.data;
    var dates = _.keys(data); // Extract keys from data object

    // Convert data into a format supported by Highcharts
    var sites = {};

    // Loop through all dates
    for (var date in data) {
      // Extract visits for each site
      for (var site of data[date]) {
        if (!sites[site.url]) {
          sites[site.url] = [];
        }
        sites[site.url].push(site.visits);
      }
    }

    // Convert object with urls as keys into a list of objects
    var series = _.map(sites, function (visits, key) {
      return {
        name: key,
        data: visits,
      }
    })

    $scope.series = series;
    $scope.dates = dates;
  });
});

/**
 * Controller for Top Referrers
 */
reports.controller('TopReferrersController', function TopReferrersController($scope, $http) {
  $scope.data = {};

  $http.get('top_referrers.json').then(function (response) {
    $scope.data = response.data;
  });
});
