#ifdef __cplusplus
extern "C" {
#endif
    
    __declspec(dllexport)
    const char* world()
    {
        return "world!\n";
    }
    
#ifdef __cplusplus
}
#endif