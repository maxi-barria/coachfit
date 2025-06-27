export const generateUniqueEmail = (prefix = 'test'): string => {
    const timestamp = Date.now();
    return `${prefix}+${timestamp}@example.com`;
};
