

export const getData = <T, K>(oldData: T, newData: K) => {

  const returnData = {
    ...oldData,
    ...newData,
  }

  return returnData as T & K;
}