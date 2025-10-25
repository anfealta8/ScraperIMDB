import random
import logging

class ProxyManager:
    def __init__(self, enabled=False):
        self.enabled = enabled
        self.proxies = [
            'http://45.77.56.109:3128',           # Proxy público 1
            'http://138.197.157.32:3128',         # Proxy público 2  
            'http://165.227.103.219:3128',        # Proxy público 3
            'http://51.158.68.68:8811',           # Proxy público 4
            'http://163.172.157.7:8811',          # Proxy público 5
        ]
        self.current_proxy = None
        self.logger = logging.getLogger(__name__)
        
        if self.enabled:
            self.current_proxy = random.choice(self.proxies)
            self.logger.info(f"🔧 PROXIES HABILITADOS - Usando: {self.current_proxy}")

    def get_proxy(self):
        """Obtener proxy actual o None si está deshabilitado"""
        if not self.enabled:
            return None
        return self.current_proxy

    def rotate_proxy(self):
        """Rotar al siguiente proxy"""
        if not self.enabled or len(self.proxies) <= 1:
            return None
            
        old_proxy = self.current_proxy
        available = [p for p in self.proxies if p != self.current_proxy]
        self.current_proxy = random.choice(available) if available else self.proxies[0]
        
        self.logger.info(f"🔄 PROXY ROTADO: {old_proxy} -> {self.current_proxy}")
        return self.current_proxy


proxy_manager = ProxyManager(enabled=False)  # Por defecto DESHABILITADO