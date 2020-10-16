export default (arr1: Array<string>, arr2: Array<string>) => {
  const intersection = arr1.filter((item) => arr2.includes(item)).length;
  const union = arr1.length + arr2.length - intersection;
  return intersection / union;
};
