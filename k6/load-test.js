
  import http from 'k6/http';
  import { check, sleep } from 'k6';

  export const options = {
      stages: [
          { duration: '30s', target: 10 },   // 10명까지 증가
          { duration: '1m', target: 50 },    // 50명 유지
          { duration: '30s', target: 0 },    // 종료
      ],
      thresholds: {
          http_req_duration: ['p(95)<500'],  // 95% 요청 500ms 이내
          http_req_failed: ['rate<0.01'],    // 에러율 1% 미만
      },
  };


  const BASE_URL = 'http://localhost:8080';

  export default function () {
      // 메인 페이지
      let res1 = http.get(`${BASE_URL}/`);
      check(res1, { '메인 200': (r) => r.status === 200 });
      sleep(1);

      // 상품 목록
      let res2 = http.get(`${BASE_URL}/trade/list`);
      check(res2, { '상품목록 200': (r) => r.status === 200 });
      sleep(1);

      // 헬스체크
      let res3 = http.get(`${BASE_URL}/health`);
      check(res3, { '헬스 200': (r) => r.status === 200 });
      sleep(1);
  }