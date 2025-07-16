(function(){
    function a(){
        const b=document.querySelectorAll('.fade-in'),c=window.innerHeight;
        b.forEach(d=>{
            const e=d.getBoundingClientRect().top;
            if(e<c-60){
                d.classList.add('visible');
            }
        });
    }
    window.addEventListener('scroll',a);
    window.addEventListener('DOMContentLoaded',a);
})();
